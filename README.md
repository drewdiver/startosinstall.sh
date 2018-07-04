# startosinstall.sh

I needed a quick way to re-install macOS High Sierra on a machine (and possibly
with a package or two). After chatting with [Armin](https://scriptingosx.com) on
the Mac Admins Slack this idea was born. A lot of  credit to Greg Neagle as this is basically a re-working of [Bootstrappr](https://github.com/munki/bootstrappr) to utilize
High Sierra's `startosinstall` feature.

## Usage
1. Copy a macOS 10.13 or 10.14 beta, the `startosinstall.sh` script and (if
   needed) a folder named "Packages" containing the distribution packages you need to the root of a thumb
   drive.
2. Boot the Mac into recovery (option + command + r)
3. If needed, erase the local drive (see caveats below)
4. Open a Terminal from the Utilties menu
4. /Volumes/YOUR_EXTERNAL/startosinstall.sh
5. Select the volume you'd like to install to
6. The machine will reboot and begin the installation

## Note
- The script checks for a Packages folder, if one is not present, the script
  will run without adding additional packages.

- When including packages, they must be of type Distribution (built with `productbuild`)

- Included a wildcard for macOS version so either High Sierra *OR* Mojave beta can
be used.

## Caveats
`--eraseinstall can not be used in conjunction with --volume`
This means you will have to run Disk Utility from Recovery mode to erase the
volume prior to running or verifying the Volume name with `diskutil list` and issuing a `diskutil
eraseVolume APFS Macintosh\ HD /dev/disk2s1`

Perhaps this logic could be automated in the script itself?

## To-do
- Perhaps this could be made a dmg, similar to the workflow included with
Bootstrappr?
