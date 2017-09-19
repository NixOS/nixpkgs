{ stdenv }:

stdenv.mkDerivation {
  name = "cc-wrapper-test";

  buildCommand = ''
    NIX_DEBUG=1 $CC -v
    NIX_DEBUG=1 $CXX -v

    printf "checking whether compiler builds valid C binaries... " >&2
    $CC -o cc-check ${./cc-main.c}
    ./cc-check

    printf "checking whether compiler builds valid C++ binaries... " >&2
    $CXX -o cxx-check ${./cxx-main.cc}
    ./cxx-check

    ${stdenv.lib.optionalString (stdenv.isDarwin && stdenv.cc.isClang) ''
      printf "checking whether compiler can build with CoreFoundation.framework... " >&2
      mkdir -p foo/lib
      $CC -framework CoreFoundation -o core-foundation-check ${./core-foundation-main.c}
      ./core-foundation-check
    ''}

    printf "checking whether compiler uses NIX_CFLAGS_COMPILE... " >&2
    mkdir -p foo/include
    cp ${./foo.c} foo/include/foo.h
    NIX_CFLAGS_COMPILE="-Ifoo/include -DVALUE=42" $CC -o cflags-check ${./cflags-main.c}
    ./cflags-check

    printf "checking whether compiler uses NIX_LDFLAGS... " >&2
    mkdir -p foo/lib
    $CC -shared \
      ${stdenv.lib.optionalString stdenv.isDarwin "-Wl,-install_name,@rpath/libfoo.dylib"} \
      -DVALUE=42 \
      -o foo/lib/libfoo${stdenv.hostPlatform.extensions.sharedLibrary} \
      ${./foo.c}

    NIX_LDFLAGS="-L$NIX_BUILD_TOP/foo/lib -rpath $NIX_BUILD_TOP/foo/lib" $CC -lfoo -o ldflags-check ${./ldflags-main.c}
    ./ldflags-check

    touch $out
  '';

  meta.platforms = stdenv.lib.platforms.all;
}
