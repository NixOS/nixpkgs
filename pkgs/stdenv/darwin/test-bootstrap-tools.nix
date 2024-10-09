{
  lib,
  stdenv,
  bootstrapTools,
  hello,
}:

builtins.derivation {
  name = "test-bootstrap-tools";

  inherit (stdenv.hostPlatform) system;

  builder = "${bootstrapTools}/bin/bash";

  args = [
    "-euo"
    "pipefail"
    "-c"
    "eval \"$buildCommand\""
  ];

  PATH = lib.makeBinPath [ bootstrapTools ];

  tools = bootstrapTools;

  "${stdenv.cc.darwinMinVersionVariable}" = stdenv.cc.darwinMinVersion;

  # Create a pure environment where we use just what's in the bootstrap tools.
  buildCommand = ''
    mkdir -p $out/bin

    for exe in $tools/bin/*; do
      [[ $exe =~ bunzip2|codesign.*|false|install_name_tool|ld|lipo|pbzx|ranlib|rewrite-tbd|sigtool ]] && continue
      $exe --version > /dev/null || { echo $exe failed >&2; exit 1; }
    done

    # run all exes that don't take a --version flag
    bunzip2 -h
    codesign --help
    codesign_allocate -i $tools/bin/true -r -o true
    false || (($? == 1))
    install_name_tool -id true true
    ld -v
    lipo -info true
    pbzx -v
    # ranlib gets tested bulding hello
    rewrite-tbd </dev/null
    sigtool -h
    rm true

    # The grep will return a nonzero exit code if there is no match, and we want to assert that we have
    # an SSL-capable curl
    curl --version | grep SSL

    # This approximates a bootstrap version of libSystem can that be
    # assembled via fetchurl. Adapted from main libSystem expression.
    mkdir libSystem-boot
    cp -vr \
      ${stdenv.cc.libc_dev}/lib/libSystem.B.tbd \
      ${stdenv.cc.libc_dev}/lib/system \
      libSystem-boot

    sed -i "s|/usr/lib/system/|$PWD/libSystem-boot/system/|g" libSystem-boot/libSystem.B.tbd
    ln -s libSystem.B.tbd libSystem-boot/libSystem.tbd
    # End of bootstrap libSystem

    export flags="-idirafter $tools/include-Libsystem --sysroot=$tools -L$tools/lib -L$PWD/libSystem-boot"

    export CPP="clang -E $flags"
    export CC="clang $flags"
    export CXX="clang++ $flags --stdlib=libc++ -isystem$tools/include/c++/v1"

    # NOTE: These tests do a separate 'install' step (using cp), because
    # having clang write directly to the final location apparently will make
    # running the executable fail signature verification. (SIGKILL'd)
    #
    # Suspect this is creating a corrupt entry in the kernel cache, but it is
    # unique to cctools ld. (The problem goes away with `-fuse-ld=lld`.)

    echo '#include <stdio.h>' >> hello1.c
    echo '#include <float.h>' >> hello1.c
    echo '#include <limits.h>' >> hello1.c
    echo 'int main() { printf("Hello World\n"); return 0; }' >> hello1.c
    $CC -o hello1 hello1.c
    cp hello1 $out/bin/
    $out/bin/hello1

    echo '#include <iostream>' >> hello3.cc
    echo 'int main() { std::cout << "Hello World\n"; }' >> hello3.cc
    $CXX -v -o hello3 hello3.cc
    cp hello3 $out/bin/
    $out/bin/hello3

    # test that libc++.dylib rpaths are correct so it can reference libc++abi.dylib when linked.
    # using -Wl,-flat_namespace is required to generate an error
    mkdir libtest/
    ln -s $tools/lib/libc++.dylib libtest/
    clang++ -Wl,-flat_namespace -idirafter $tools/include-Libsystem -isystem$tools/include/c++/v1 \
      --sysroot=$tools -L./libtest -L$PWD/libSystem-boot hello3.cc

    tar xvf ${hello.src}
    cd hello-*
    # hello configure detects -liconv is needed but doesn't add to the link step
    LDFLAGS=-liconv ./configure --prefix=$out
    make
    make install
    $out/bin/hello
  '';
}
