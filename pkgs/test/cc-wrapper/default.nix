{ lib, stdenv, glibc, buildPackages }:

let
  # Sanitizers are not supported on Darwin.
  # Sanitizer headers aren't available in older libc++ stdenvs due to a bug
  sanitizersWorking = (stdenv.buildPlatform == stdenv.hostPlatform) && !stdenv.isDarwin && !stdenv.hostPlatform.isMusl && (
    (stdenv.cc.isClang && lib.versionAtLeast (lib.getVersion stdenv.cc.name) "5.0.0")
    || (stdenv.cc.isGNU && stdenv.isLinux)
  );
  staticLibc = lib.optionalString (stdenv.hostPlatform.libc == "glibc") "-L ${glibc.static}/lib";
  emulator = stdenv.hostPlatform.emulator buildPackages;
<<<<<<< HEAD
  libcxxStdenvSuffix = lib.optionalString (stdenv.cc.libcxx != null) "-libcxx";
in stdenv.mkDerivation {
  pname = "cc-wrapper-test-${stdenv.cc.cc.pname}${libcxxStdenvSuffix}";
  version = stdenv.cc.version;

  buildCommand = ''
    echo "Testing: ${stdenv.cc.name}" >&2
    echo "With libc: ${stdenv.cc.libc.name}" >&2
=======
in stdenv.mkDerivation {
  name = "cc-wrapper-test";

  buildCommand = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    set -o pipefail

    NIX_DEBUG=1 $CC -v
    NIX_DEBUG=1 $CXX -v

<<<<<<< HEAD
    echo "checking whether compiler builds valid C binaries... " >&2
    $CC -o cc-check ${./cc-main.c}
    ${emulator} ./cc-check

    echo "checking whether compiler builds valid C++ binaries... " >&2
=======
    printf "checking whether compiler builds valid C binaries... " >&2
    $CC -o cc-check ${./cc-main.c}
    ${emulator} ./cc-check

    printf "checking whether compiler builds valid C++ binaries... " >&2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    $CXX -o cxx-check ${./cxx-main.cc}
    ${emulator} ./cxx-check

    ${lib.optionalString (stdenv.isDarwin && stdenv.cc.isClang) ''
<<<<<<< HEAD
      echo "checking whether compiler can build with CoreFoundation.framework... " >&2
=======
      printf "checking whether compiler can build with CoreFoundation.framework... " >&2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      mkdir -p foo/lib
      $CC -framework CoreFoundation -o core-foundation-check ${./core-foundation-main.c}
      ${emulator} ./core-foundation-check
    ''}


    ${lib.optionalString (!stdenv.isDarwin) ''
<<<<<<< HEAD
      echo "checking whether compiler builds valid static C binaries... " >&2
      $CC ${staticLibc} -static -o cc-static ${./cc-main.c}
      ${emulator} ./cc-static
      ${lib.optionalString (stdenv.cc.isGNU && lib.versionAtLeast (lib.getVersion stdenv.cc.name) "8.0.0") ''
        echo "checking whether compiler builds valid static pie C binaries... " >&2
=======
      printf "checking whether compiler builds valid static C binaries... " >&2
      $CC ${staticLibc} -static -o cc-static ${./cc-main.c}
      ${emulator} ./cc-static
      ${lib.optionalString (stdenv.cc.isGNU && lib.versionAtLeast (lib.getVersion stdenv.cc.name) "8.0.0") ''
        printf "checking whether compiler builds valid static pie C binaries... " >&2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        $CC ${staticLibc} -static-pie -o cc-static-pie ${./cc-main.c}
        ${emulator} ./cc-static-pie
      ''}
    ''}

    ${# See: https://github.com/llvm/llvm-project/commit/ed1d07282cc9d8e4c25d585e03e5c8a1b6f63a74
      # `gcc` does not support this so we gate the test on `clang`
      lib.optionalString stdenv.cc.isClang ''
<<<<<<< HEAD
        echo "checking whether cc-wrapper accepts -- followed by positional (file) args..." >&2
=======
        printf "checking whether cc-wrapper accepts -- followed by positional (file) args..." >&2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        mkdir -p positional

        # Make sure `--` is not parsed as a "non flag arg"; we should get an
        # input file error here and *not* a linker error.
        { ! $CC --; } |& grep -q "no input files"

        # And that positional file args _must_ be files (this is just testing
        # that we remembered to put the `--` back in the args to the compiler):
        { ! $CC -c -- -o foo ${./foo.c}; } \
          |& grep -q "no such file or directory: '-o'"

        # Now check that we accept single and multiple positional file args:
        $CC -c -DVALUE=42 -o positional/foo.o -- ${./foo.c}
        $CC -o positional/main -- positional/foo.o ${./ldflags-main.c}
        ${emulator} ./positional/main
    ''}

<<<<<<< HEAD
    echo "checking whether compiler uses NIX_CFLAGS_COMPILE... " >&2
=======
    printf "checking whether compiler uses NIX_CFLAGS_COMPILE... " >&2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mkdir -p foo/include
    cp ${./foo.c} foo/include/foo.h
    NIX_CFLAGS_COMPILE="-Ifoo/include -DVALUE=42" $CC -o cflags-check ${./cflags-main.c}
    ${emulator} ./cflags-check

<<<<<<< HEAD
    echo "checking whether compiler uses NIX_LDFLAGS... " >&2
=======
    printf "checking whether compiler uses NIX_LDFLAGS... " >&2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mkdir -p foo/lib
    $CC -shared \
      ${lib.optionalString stdenv.isDarwin "-Wl,-install_name,@rpath/libfoo.dylib"} \
      -DVALUE=42 \
      -o foo/lib/libfoo${stdenv.hostPlatform.extensions.sharedLibrary} \
      ${./foo.c}

    NIX_LDFLAGS="-L$NIX_BUILD_TOP/foo/lib -rpath $NIX_BUILD_TOP/foo/lib" $CC -lfoo -o ldflags-check ${./ldflags-main.c}
    ${emulator} ./ldflags-check

<<<<<<< HEAD
    echo "Check whether -nostdinc and -nostdinc++ is handled correctly" >&2
=======
    printf "Check whether -nostdinc and -nostdinc++ is handled correctly" >&2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mkdir -p std-include
    cp ${./stdio.h} std-include/stdio.h
    NIX_DEBUG=1 $CC -I std-include -nostdinc -o nostdinc-main ${./nostdinc-main.c}
    ${emulator} ./nostdinc-main
    $CXX -I std-include -nostdinc++ -o nostdinc-main++ ${./nostdinc-main.c}
    ${emulator} ./nostdinc-main++

    ${lib.optionalString sanitizersWorking ''
<<<<<<< HEAD
      echo "checking whether sanitizers are fully functional... ">&2
=======
      printf "checking whether sanitizers are fully functional... ">&2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      $CC -o sanitizers -fsanitize=address,undefined ${./sanitizers.c}
      ASAN_OPTIONS=use_sigaltstack=0 ${emulator} ./sanitizers
    ''}

    touch $out
  '';

  meta.platforms = lib.platforms.all;
}
