{
  lib,
  stdenv,
  apple-sdk,
  bootstrapTools,
  hello,
}:

derivation {
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
      [[ $exe =~ bunzip2|codesign.*|false|install_name_tool|ld|lipo|pbzx|ranlib|sigtool ]] && continue
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
    sigtool -h
    rm true

    # The grep will return a nonzero exit code if there is no match, and we want to assert that we have
    # an SSL-capable curl
    curl --version | grep SSL

    # The stdenv bootstrap builds the SDK in the bootstrap. Use an existing SDK to test the tools.
    export SDKROOT='${apple-sdk.sdkroot}'

    export resource_dir="$(echo "$tools"/lib/clang/*)" # Expand wildcard
    export flags="-resource-dir=$resource_dir -idirafter $SDKROOT/usr/include --sysroot=$SDKROOT -L$SDKROOT/usr/lib -L$tools/lib -DTARGET_OS_IPHONE=0"

    export CPP="clang -E $flags"
    export CC="clang $flags"
    export CXX="clang++ $flags --stdlib=libc++ -isystem$tools/include/c++/v1"

    echo '#include <stdio.h>' >> hello1.c
    echo '#include <float.h>' >> hello1.c
    echo '#include <limits.h>' >> hello1.c
    echo 'int main() { printf("Hello World\n"); return 0; }' >> hello1.c
    $CC -o $out/bin/hello1 hello1.c
    $out/bin/hello1

    echo '#include <iostream>' >> hello3.cc
    echo 'int main() { std::cout << "Hello World\n"; }' >> hello3.cc
    $CXX -v -o $out/bin/hello3 hello3.cc
    $out/bin/hello3

    # test that libc++.dylib rpaths are correct so it can reference libc++abi.dylib when linked.
    # using -Wl,-flat_namespace is required to generate an error
    mkdir libtest/
    ln -s $tools/lib/libc++.dylib libtest/
    clang++ -Wl,-flat_namespace -resource-dir=$resource_dir -idirafter $SDKROOT/usr/include -isystem$tools/include/c++/v1 \
      --sysroot=$SDKROOT -L$SDKROOT/usr/lib  -L./libtest -L$PWD/libSystem-boot hello3.cc

    tar xvf ${hello.src}
    cd hello-*
    # hello configure detects -liconv is needed but doesn't add to the link step
    LDFLAGS=-liconv ./configure --prefix=$out
    make
    make install
    $out/bin/hello
  '';
}
