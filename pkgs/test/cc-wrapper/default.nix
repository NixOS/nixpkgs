{ lib, stdenv, glibc }:

let
  # Sanitizers are not supported on Darwin.
  # Sanitizer headers aren't available in older libc++ stdenvs due to a bug
  sanitizersWorking = !stdenv.hostPlatform.isMusl && (
    (stdenv.cc.isClang && lib.versionAtLeast (lib.getVersion stdenv.cc.name) "5.0.0")
    || (stdenv.cc.isGNU && stdenv.isLinux)
  );
  staticLibc = lib.optionalString (stdenv.hostPlatform.libc == "glibc") "-L ${glibc.static}/lib";
in stdenv.mkDerivation {
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

    ${lib.optionalString (stdenv.isDarwin && stdenv.cc.isClang) ''
      printf "checking whether compiler can build with CoreFoundation.framework... " >&2
      mkdir -p foo/lib
      $CC -framework CoreFoundation -o core-foundation-check ${./core-foundation-main.c}
      ./core-foundation-check
    ''}


    ${lib.optionalString (!stdenv.isDarwin) ''
      printf "checking whether compiler builds valid static C binaries... " >&2
      $CC ${staticLibc} -static -o cc-static ${./cc-main.c}
      ./cc-static
      # our glibc does not have pie enabled yet.
      ${lib.optionalString (stdenv.hostPlatform.isMusl && stdenv.cc.isGNU) ''
        printf "checking whether compiler builds valid static pie C binaries... " >&2
        $CC ${staticLibc} -static-pie -o cc-static-pie ${./cc-main.c}
        ./cc-static-pie
      ''}
    ''}

    printf "checking whether compiler uses NIX_CFLAGS_COMPILE... " >&2
    mkdir -p foo/include
    cp ${./foo.c} foo/include/foo.h
    NIX_CFLAGS_COMPILE="-Ifoo/include -DVALUE=42" $CC -o cflags-check ${./cflags-main.c}
    ./cflags-check

    printf "checking whether compiler uses NIX_LDFLAGS... " >&2
    mkdir -p foo/lib
    $CC -shared \
      ${lib.optionalString stdenv.isDarwin "-Wl,-install_name,@rpath/libfoo.dylib"} \
      -DVALUE=42 \
      -o foo/lib/libfoo${stdenv.hostPlatform.extensions.sharedLibrary} \
      ${./foo.c}

    NIX_LDFLAGS="-L$NIX_BUILD_TOP/foo/lib -rpath $NIX_BUILD_TOP/foo/lib" $CC -lfoo -o ldflags-check ${./ldflags-main.c}
    ./ldflags-check

    printf "Check whether -nostdinc and -nostdinc++ is handled correctly" >&2
    mkdir -p std-include
    cp ${./stdio.h} std-include/stdio.h
    NIX_DEBUG=1 $CC -I std-include -nostdinc -o nostdinc-main ${./nostdinc-main.c}
    ./nostdinc-main
    $CXX -I std-include -nostdinc++ -o nostdinc-main++ ${./nostdinc-main.c}
    ./nostdinc-main++

    ${lib.optionalString sanitizersWorking ''
      printf "checking whether sanitizers are fully functional... ">&2
      $CC -o sanitizers -fsanitize=address,undefined ${./sanitizers.c}
      ./sanitizers
    ''}

    touch $out
  '';

  meta.platforms = lib.platforms.all;
}
