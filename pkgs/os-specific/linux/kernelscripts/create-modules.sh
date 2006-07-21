#! /bin/sh -e

archivesDir=/

kernel=$(@nix@/bin/nix-store -r $(echo '(import @kernelpkgs@).kernel' | @nix@/bin/nix-instantiate -))

ov511=$(@nix@/bin/nix-store -r $(echo '(import @kernelpkgs@).ov511' | @nix@/bin/nix-instantiate -))

module_init_tools=$(@nix@/bin/nix-store -r $(echo '(import @kernelpkgs@).module_init_tools' | @nix@/bin/nix-instantiate -))

kernelVersion=$(cd $kernel/lib/modules/; @coreutils@/bin/ls -d *)

echo removing old kernel tree

@coreutils@/bin/rm -rf $archivesDir/lib/modules/$kernelVersion

echo making new kernel tree

@coreutils@/bin/mkdir -p $archivesDir/lib/modules/$kernelVersion

cd $kernel

echo making kernel directories

@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type d | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/mkdir -p $archivesDir/%

echo symlinking kernel modules

@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" \
  -a -not -path "./System*" -a -not -path "./vmlinuz*" \
 -type f | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/ln -s $kernel/% $archivesDir/%

echo making ov511 directories

cd $ov511
@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type d | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/mkdir -p $archivesDir/%

echo symlinking ov511 modules

@findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type f | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/ln -s $ov511/% $archivesDir/%

echo running depmod

@module_init_tools@/sbin/depmod -ae
