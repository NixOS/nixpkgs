#! /bin/sh -e

#archivesDir=$(@mktemp@/bin/mktemp -d)
archivesDir=/

cpwd=@coreutils@/bin/pwd

storeExpr=$(@nix@/bin/nix-store -qR $(@nix@/bin/nix-store -r $(echo '(import @kernelpkgs@).everything' | @nix@/bin/nix-instantiate -)))

kernel=$(@nix@/bin/nix-store -r $(echo '(import @kernelpkgs@).kernel' | @nix@/bin/nix-instantiate -))

ov511=$(@nix@/bin/nix-store -r $(echo '(import @kernelpkgs@).ov511' | @nix@/bin/nix-instantiate -))

#echo making kernel stuff

kernelVersion=$(cd $kernel/lib/modules/; @coreutils@/bin/ls -d *)

echo removing old kernel tree

@coreutils@/bin/rm -rf $archivesDir/lib/modules/$kernelVersion

echo making new kernel tree

@coreutils@/bin/mkdir -p $archivesDir/lib/modules/$kernelVersion

#echo $kernelVersion

cd $kernel

echo making kernel directories

@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type d | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/mkdir -p $archivesDir/%

echo linking kernel modules

@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type f | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/ln -s $kernel/% $archivesDir/%

echo making ov511 directories

cd $ov511
@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type d | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/mkdir -p $archivesDir/%

echo linking ov511 modules

@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type f | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/ln -s $ov511/% $archivesDir/%
