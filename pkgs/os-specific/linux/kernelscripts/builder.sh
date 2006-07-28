source $stdenv/setup

export MODULE_DIR=$out/lib/modules/

kernelVersion=$(cd $kernel/lib/modules/; ls -d *)

mkdir -p $out/lib/modules/$kernelVersion

cd $kernel

echo making kernel directories

find . -not -path "./lib/modules/$kernelVersion/build*" -type d | xargs -n 1 -i% mkdir -p $out/%

echo symlinking kernel modules

find . -not -path "./lib/modules/$kernelVersion/build*" -a -not -path \
  "./System*" -a -not -path "./vmlinuz*" -type f | xargs -n 1 -i% \
  ln -s $kernel/% $out/%

echo $modules
for i in $modules; do
  echo making directories for $i
  cd $i
  find . -not -path "./lib/modules/$kernelVersion/build*" -type d | xargs -n 1 -i% mkdir -p $out/%

  echo symlinking modules for $i

  find . -not -path "./lib/modules/$kernelVersion/build*" -type f | xargs -n 1 -i% ln -s $i/% $out/%

done

echo running depmod
$module_init_tools/sbin/depmod -ae $kernelVersion
