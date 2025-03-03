{
  runCommand,
  llvm,
  lld,
}:

runCommand "rocm-llvm-binutils-${llvm.version}" { preferLocalBuild = true; } ''
  mkdir -p $out/bin

  for prog in ${lld}/bin/*; do
    ln -s $prog $out/bin/$(basename $prog)
  done

  for prog in ${llvm}/bin/*; do
    ln -sf $prog $out/bin/$(basename $prog)
  done

  ln -s ${llvm}/bin/llvm-ar $out/bin/ar
  ln -s ${llvm}/bin/llvm-as $out/bin/as
  ln -s ${llvm}/bin/llvm-dwp $out/bin/dwp
  ln -s ${llvm}/bin/llvm-nm $out/bin/nm
  ln -s ${llvm}/bin/llvm-objcopy $out/bin/objcopy
  ln -s ${llvm}/bin/llvm-objdump $out/bin/objdump
  ln -s ${llvm}/bin/llvm-ranlib $out/bin/ranlib
  ln -s ${llvm}/bin/llvm-readelf $out/bin/readelf
  ln -s ${llvm}/bin/llvm-size $out/bin/size
  ln -s ${llvm}/bin/llvm-strip $out/bin/strip
  ln -s ${lld}/bin/lld $out/bin/ld
''
