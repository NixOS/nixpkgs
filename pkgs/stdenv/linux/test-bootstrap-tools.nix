{
  lib,
  stdenv,
  binutils,
  busybox,
  bootstrapTools,
  hello,
}:

builtins.derivation {
  name = "test-bootstrap-tools";
  inherit (stdenv.hostPlatform) system; # We cannot "cross test"
  builder = busybox;
  args = [
    "ash"
    "-e"
    "-c"
    "eval \"$buildCommand\""
  ];

  buildCommand =
    ''
      export PATH=${bootstrapTools}/bin

      ls -l
      mkdir $out
      mkdir $out/bin
      sed --version
      find --version
      diff --version
      patch --version
      make --version
      awk --version
      grep --version
      gcc --version

    ''
    + lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
      rtld=$(echo ${bootstrapTools}/lib/${builtins.unsafeDiscardStringContext # only basename
        (builtins.baseNameOf binutils.dynamicLinker)})
      libc_includes=${bootstrapTools}/include-glibc
    ''
    + lib.optionalString (stdenv.hostPlatform.libc == "musl") ''
      rtld=$(echo ${bootstrapTools}/lib/ld-musl*.so.?)
      libc_includes=${bootstrapTools}/include-libc
    ''
    + ''
      # path to version-specific libraries, like libstdc++.so
      cxx_libs=$(echo ${bootstrapTools}/lib/gcc/*/*)
      export CPP="cpp -idirafter $libc_includes -B${bootstrapTools}"
      export  CC="gcc -idirafter $libc_includes -B${bootstrapTools} -Wl,-dynamic-linker,$rtld -Wl,-rpath,${bootstrapTools}/lib -Wl,-rpath,$cxx_libs"
      export CXX="g++ -idirafter $libc_includes -B${bootstrapTools} -Wl,-dynamic-linker,$rtld -Wl,-rpath,${bootstrapTools}/lib -Wl,-rpath,$cxx_libs"

      echo '#include <stdio.h>' >> foo.c
      echo '#include <limits.h>' >> foo.c
      echo 'int main() { printf("Hello World\\n"); return 0; }' >> foo.c
      $CC -o $out/bin/foo foo.c
      $out/bin/foo

      echo '#include <iostream>' >> bar.cc
      echo 'int main() { std::cout << "Hello World\\n"; }' >> bar.cc
      $CXX -v -o $out/bin/bar bar.cc
      $out/bin/bar

      tar xvf ${hello.src}
      cd hello-*
      ./configure --prefix=$out
      make
      make install
    '';
}
