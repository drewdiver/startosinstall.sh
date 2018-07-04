#!/bin/bash

# startosinstall.sh
# See README.md for usage

BASENAME=${0##*/}
THISDIR=${0%$BASENAME}
INSTALLER=$(ls ${THISDIR}/* | grep -q "Install macOS")
PACKAGESDIR="${THISDIR}Packages"
INDEX=0
IFS=$'\n'

sanity_check () {
    # are we root?
    if [[ $EUID != 0 ]] ; then
        echo "Please run as root or with sudo!"
        exit 1
    fi

    # make sure a macOS installer is present.
    if [[ ${INSTALLER} -ne 0 ]]; then
        echo "macOS Installer not found, exiting!"
        exit 1
    fi
}

volume_select () {
    echo "Please select the volume you wish to install to..."
    echo "Available Volumes:"
    for VOLUME in $(/bin/ls -1 /Volumes); do
        if [[ "${VOLUME}" != "OS X Base System" ]]; then
            # let
            ((INDEX=INDEX+1))
	    VOLUMES[${INDEX}]=${VOLUME}
	    echo "    ${INDEX}  ${VOLUME}"
        fi
    done

    read -r -p "Install to Volume # (1-${INDEX}): " SELECTEDINDEX

    SELECTEDVOLUME=${VOLUMES[${SELECTEDINDEX}]}

    if [[ "${SELECTEDVOLUME}" == "" ]]; then
        echo "Selection not valid, exiting."
        exit 1
    fi
}

startosinstall () {
    PKGCOUNT=0
    if [[ -d "${PACKAGESDIR}" ]]; then
        for PKG in "${PACKAGESDIR}"/* ; do
	    FILENAME="${PKG##*/}"
	    EXTENSION="${FILENAME##*.}"
	    if [[ -e ${PKG} ]]; then
	        case ${EXTENSION} in
		    pkg )
		        echo "Appending: ${FILENAME} to startosinstall..."
		        PACKAGES+=(--installpackage "${PKG}")
                        ((PKGCOUNT=PKGCOUNT+1)) 
		        ;;
		    * ) echo "Unsupported file extension ${PKG}" ;;
	        esac
	    fi
        done
        echo "Installing macOS to ${SELECTEDVOLUME} with ${PKGCOUNT} package(s)..."
        "${THISDIR}"Install\ macOS\ *.app/Contents/Resources/startosinstall \
		    --volume "/Volumes/${SELECTEDVOLUME}" --converttoapfs YES "${PACKAGES[@]}" --agreetolicense
    else
        echo "Packages firectory not found, continuing macOS install to ${SELECTEDVOLUME}..."
        "${THISDIR}"Install\ macOS\ *.app/Contents/Resources/startosinstall \
	            --volume "/Volumes/${SELECTEDVOLUME}" --converttoapfs YES --agreetolicense  
    fi
}

# Main

sanity_check
volume_select
startosinstall
