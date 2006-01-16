#! /bin/sh -e

#archivesDir=$(@mktemp@/bin/mktemp -d)
archivesDir=/

cpwd=@coreutils@/bin/pwd

storeExpr=$(@nix@/bin/nix-store -qR $(@nix@/bin/nix-store -r $(echo '(import ./kernel.nix).everything' | @nix@/bin/nix-instantiate -)))

kernel=$(@nix@/bin/nix-store -r $(echo '(import ./kernel.nix).kernel' | @nix@/bin/nix-instantiate -))

ov511=$(@nix@/bin/nix-store -r $(echo '(import ./kernel.nix).ov511' | @nix@/bin/nix-instantiate -))

#echo making kernel stuff

kernelVersion=$(cd $kernel/lib/modules/; @coreutils@/bin/ls -d *)
@coreutils@/bin/mkdir -p $archivesDir/lib/modules/$kernelVersion

#echo $kernelVersion

cd $kernel

# make directories

@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type d | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/mkdir -p $archivesDir/%

# link all files
@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type f | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/ln -s $kernel/% $archivesDir/%

# make directories

cd $ov511
@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type d | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/mkdir -p $archivesDir/%

# link all files
@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type f | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/ln -s $ov511/% $archivesDir/%
