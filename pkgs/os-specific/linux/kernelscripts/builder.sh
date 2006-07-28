#! /bin/sh -e

export MODULE_DIR=$out/lib/modules

kernelVersion=$(cd $kernel/lib/modules/; ls -d *)

mkdir -p $out/lib/modules/$kernelVersion

cd $kernel

# making kernel directories

find . -not -path "./lib/modules/$kernelVersion/build*" -type d | xargs -n 1 -i% mkdir -p $out/%

# symlinking kernel modules

find . -not -path "./lib/modules/$kernelVersion/build*" -a -not -path \
  "./System*" -a -not -path "./vmlinuz*" -type f | xargs -n 1 -i% \
  ln -s $kernel/% $archivesDir/%

# echo making ov511 directories

# cd $ov511
# @findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type d | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/mkdir -p $archivesDir/%
# 
# echo symlinking ov511 modules
# 
# @findutils@/bin/find . -not -path "./lib/modules/$kernelVersion/build*" -type f | @findutils@/bin/xargs -n 1 -i% @coreutils@/bin/ln -s $ov511/% $archivesDir/%

# running depmod
$module_init_tools/sbin/depmod -ae
