#! /bin/sh -e

archivesDir=$(mktemp -d)
manifest=${archivesDir}/MANIFEST
nixpkgs=/nixpkgs/trunk/pkgs
fill_disk=$archivesDir/scripts/fill-disk.sh
ramdisk_login=$archivesDir/scripts/ramdisk-login.sh
storePaths=$archivesDir/mystorepaths
validatePaths=$archivesDir/validatepaths
bootiso=/tmp/nixos.iso
initrd=/tmp/initram.img
initdir=${archivesDir}/initdir
initscript=$archivesDir/scripts/init.sh

NIX_CMD_PATH=$(dirname $(which nix-store))
cpwd=`pwd`

storeExpr=$($NIX_CMD_PATH/nix-store -qR $($NIX_CMD_PATH/nix-store -r $(echo '(import ./kernel.nix).everything' | $NIX_CMD_PATH/nix-instantiate -)))

kernel=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./kernel.nix).kernel' | $NIX_CMD_PATH/nix-instantiate -))

ov511=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./kernel.nix).ov511' | $NIX_CMD_PATH/nix-instantiate -))

echo $kernel
echo $ov511

echo making kernel stuff

kernelVersion=$(cd $kernel/lib/modules/; ls -d *)
mkdir -p $archivesDir/lib/modules/$kernelVersion

echo $kernelVersion

cd $kernel

# make directories

find . -not -path "./lib/modules/$kernelVersion/build*" -type d | xargs -n 1 -i% mkdir -p $archivesDir/%

# link all files
find . -not -path "./lib/modules/$kernelVersion/build*" -type f | xargs -n 1 -i% ln -s $kernel/% $archivesDir/%

# make directories

cd $ov511
find . -not -path "./lib/modules/$kernelVersion/build*" -type d | xargs -n 1 -i% mkdir -p $archivesDir/%

# link all files
find . -not -path "./lib/modules/$kernelVersion/build*" -type f | xargs -n 1 -i% ln -s $ov511/% $archivesDir/%
