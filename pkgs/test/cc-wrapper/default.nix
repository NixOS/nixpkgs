{
  lib,
  stdenv,
  glibc,
  buildPackages,
}:

let
  # Sanitizers are not supported on Darwin.
  # Sanitizer headers aren't available in older libc++ stdenvs due to a bug
  sanitizersWorking =
    (stdenv.buildPlatform == stdenv.hostPlatform)
    && !stdenv.hostPlatform.isDarwin
    && !stdenv.hostPlatform.isMusl
    && (
      (stdenv.cc.isClang && lib.versionAtLeast (lib.getVersion stdenv.cc.name) "5.0.0")
      || (stdenv.cc.isGNU && stdenv.hostPlatform.isLinux)
    );
  staticLibc = lib.optionalString (stdenv.hostPlatform.libc == "glibc") "-L ${glibc.static}/lib";
  emulator = stdenv.hostPlatform.emulator buildPackages;
  isCxx = stdenv.cc.libcxx != null;
  libcxxStdenvSuffix = lib.optionalString isCxx "-libcxx";
  CC = "PATH= ${lib.getExe' stdenv.cc "${stdenv.cc.targetPrefix}cc"}";
  CXX = "PATH= ${lib.getExe' stdenv.cc "${stdenv.cc.targetPrefix}c++"}";
  READELF = "PATH= ${lib.getExe' stdenv.cc "${stdenv.cc.targetPrefix}readelf"}";
  # ld-wrapper only computes an rpath for ELF shared libraries.
  rpathWorking = stdenv.hostPlatform.isElf && !stdenv.hostPlatform.isStatic;
  # A shared library in a store path of its own, so that only ld-wrapper's
  # rpath logic can put its directory into the rpath.
  fooLib = stdenv.mkDerivation {
    name = "cc-wrapper-test-libfoo";
    buildCommand = ''
      mkdir -p $out/lib
      $CC -shared -DVALUE=42 -o $out/lib/libfoo.so ${./foo.c}
    '';
  };
  # A store path whose lib and sub are symlinks to fooLib's lib.
  fooLinks = stdenv.mkDerivation {
    name = "cc-wrapper-test-libfoo-links";
    buildCommand = ''
      mkdir $out
      ln -s ${fooLib}/lib $out/lib
      ln -s ${fooLib}/lib $out/sub
    '';
  };
in
stdenv.mkDerivation {
  pname = "cc-wrapper-test-${stdenv.cc.cc.pname}${libcxxStdenvSuffix}";
  version = stdenv.cc.version;

  buildCommand = ''
    echo "Testing: ${stdenv.cc.name}" >&2
    echo "With libc: ${stdenv.cc.libc.name}" >&2
    set -o pipefail

    NIX_DEBUG=1 ${CC} -v
    NIX_DEBUG=1 ${CXX} -v

    echo "checking whether compiler builds valid C binaries... " >&2
    ${CC} -o cc-check ${./cc-main.c}
    ${emulator} ./cc-check

    echo "checking whether compiler builds valid C++ binaries... " >&2
    ${CXX} -o cxx-check ${./cxx-main.cc}
    ${emulator} ./cxx-check

    # test for https://github.com/NixOS/nixpkgs/issues/214524#issuecomment-1431745905
    # .../include/cxxabi.h:20:10: fatal error: '__cxxabi_config.h' file not found
    # in libcxxStdenv
    echo "checking whether cxxabi.h can be included... " >&2
    ${CXX} -o include-cxxabi ${./include-cxxabi.cc}
    ${emulator} ./include-cxxabi

    # cxx doesn't have libatomic.so
    ${lib.optionalString (!isCxx) ''
      # https://github.com/NixOS/nixpkgs/issues/91285
      echo "checking whether libatomic.so can be linked... " >&2
      ${CXX} -shared -o atomics.so ${./atomics.cc} -latomic ${
        lib.optionalString (stdenv.cc.isClang && lib.versionOlder stdenv.cc.version "6.0.0") "-std=c++17"
      }
      ${READELF} -d ./atomics.so | grep libatomic.so && echo "ok" >&2 || echo "failed" >&2
    ''}

    # Test that linking libc++ works, and statically.
    ${lib.optionalString isCxx ''
      echo "checking whether can link with libc++... " >&2
      NIX_DEBUG=1 ${CXX} ${./cxx-main.cc} -c -o cxx-main.o
      NIX_DEBUG=1 ${CC} cxx-main.o -lc++ -o cxx-main
      NIX_DEBUG=1 ${CC} cxx-main.o ${lib.getLib stdenv.cc.libcxx}/lib/libc++.a -o cxx-main-static
      ${emulator} ./cxx-main
      ${emulator} ./cxx-main-static
      rm cxx-main{,-static,.o}
    ''}

    ${lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.cc.isClang) ''
      echo "checking whether compiler can build with CoreFoundation.framework... " >&2
      mkdir -p foo/lib
      ${CC} -framework CoreFoundation -o core-foundation-check ${./core-foundation-main.c}
      ${emulator} ./core-foundation-check
    ''}


    ${lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      echo "checking whether compiler builds valid static C binaries... " >&2
      ${CC} ${staticLibc} -static -o cc-static ${./cc-main.c}
      ${emulator} ./cc-static
      ${lib.optionalString (stdenv.cc.isGNU && lib.versionAtLeast (lib.getVersion stdenv.cc.name) "8.0.0")
        ''
          echo "checking whether compiler builds valid static pie C binaries... " >&2
          ${CC} ${staticLibc} -static-pie -o cc-static-pie ${./cc-main.c}
          ${emulator} ./cc-static-pie
        ''
      }
    ''}

    ${
      # See: https://github.com/llvm/llvm-project/commit/ed1d07282cc9d8e4c25d585e03e5c8a1b6f63a74
      # `gcc` does not support this so we gate the test on `clang`
      lib.optionalString stdenv.cc.isClang ''
        echo "checking whether cc-wrapper accepts -- followed by positional (file) args..." >&2
        mkdir -p positional

        # Make sure `--` is not parsed as a "non flag arg"; we should get an
        # input file error here and *not* a linker error.
        { ! ${CC} --; } |& grep -q "no input files"

        # And that positional file args _must_ be files (this is just testing
        # that we remembered to put the `--` back in the args to the compiler):
        { ! ${CC} -c -- -o foo ${./foo.c}; } \
          |& grep -q "no such file or directory: '-o'"

        # Now check that we accept single and multiple positional file args:
        ${CC} -c -DVALUE=42 -o positional/foo.o -- ${./foo.c}
        ${CC} -o positional/main -- positional/foo.o ${./ldflags-main.c}
        ${emulator} ./positional/main
      ''
    }

    ${
      # Check whether fuse-ld=gold works on our GNU toolchain
      # Regression test for https://github.com/NixOS/nixpkgs/issues/49071
      lib.optionalString stdenv.cc.isGNU ''
        echo "checking whether compiler builds valid C binaries... " >&2
        CFLAGS="-fuse-ld=gold" ${CC} -o cc-check ${./cc-main.c}
        ${emulator} ./cc-check
      ''
    }

    echo "checking whether compiler uses NIX_CFLAGS_COMPILE... " >&2
    mkdir -p foo/include
    cp ${./foo.c} foo/include/foo.h
    NIX_CFLAGS_COMPILE="-Ifoo/include -DVALUE=42" ${CC} -o cflags-check ${./cflags-main.c}
    ${emulator} ./cflags-check

    echo "checking whether compiler uses NIX_LDFLAGS... " >&2
    mkdir -p foo/lib
    ${CC} -shared \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "-Wl,-install_name,@rpath/libfoo.dylib"} \
      -DVALUE=42 \
      -o foo/lib/libfoo${stdenv.hostPlatform.extensions.sharedLibrary} \
      ${./foo.c}

    NIX_LDFLAGS="-L$NIX_BUILD_TOP/foo/lib -rpath $NIX_BUILD_TOP/foo/lib" ${CC} -lfoo -o ldflags-check ${./ldflags-main.c}
    ${emulator} ./ldflags-check

    ${lib.optionalString rpathWorking ''
      echo "checking whether ld-wrapper follows -L symlinks into the store for the rpath... " >&2
      mkdir links
      ln -s ${fooLib}/lib links/foo-abs
      # A relative target resolves against the link's directory, which is not
      # the working directory.
      mkdir links/sub
      ln -s ../foo-abs links/sub/foo-rel
      ln -s ${fooLib} links/foo-pkg
      # The kernel follows each symlink, including those of ancestor
      # directories, before going on, so .. applies to the symlink's target.
      # So these are all fooLib's lib, even ${fooLinks}/sub/../lib, unlike
      # ${fooLinks}/lib.
      for dir in "$NIX_BUILD_TOP/links/foo-abs" "$NIX_BUILD_TOP/links/sub/foo-rel" \
          "$NIX_BUILD_TOP/links/foo-pkg/lib" "$NIX_BUILD_TOP/links/foo-abs/../lib" \
          "${fooLinks}/sub/../lib"; do
        ${CC} -L"$dir" -lfoo -o symlink-rpath-check ${./ldflags-main.c}
        ${READELF} -d symlink-rpath-check | grep -F "${fooLib}/lib"
        ${emulator} ./symlink-rpath-check
      done

      echo "checking whether ld-wrapper keeps symlinks between store paths in the rpath... " >&2
      # Resolving them adds references to their targets (issue #454199).
      ${CC} -L${fooLinks}/lib -lfoo -o store-symlink-rpath-check ${./ldflags-main.c}
      ${READELF} -d store-symlink-rpath-check | grep -F "${fooLinks}/lib"
      ! ${READELF} -d store-symlink-rpath-check | grep -F "${fooLib}/lib"
      ${emulator} ./store-symlink-rpath-check

      echo "checking whether ld-wrapper recognizes a store whose parent is a symlink... " >&2
      # As when /nix is a symlink, which NIX_IGNORE_SYMLINK_STORE allows.  The
      # compiler is outside this store, so do not enforce purity.
      mkdir -p fake/real/store/foo
      cp -r ${fooLib}/lib fake/real/store/foo/lib
      ln -s real fake/nix
      ln -s "$NIX_BUILD_TOP/fake/nix/store/foo/lib" links/fake-store
      for dir in "$NIX_BUILD_TOP/fake/nix/store/foo/lib" "$NIX_BUILD_TOP/links/fake-store"; do
        NIX_ENFORCE_PURITY= NIX_STORE="$NIX_BUILD_TOP/fake/nix/store" ${CC} -L"$dir" -lfoo -o fake-store-rpath-check ${./ldflags-main.c}
        ${READELF} -d fake-store-rpath-check | grep -F "$NIX_BUILD_TOP/fake/nix/store/foo/lib"
      done

      echo "checking whether ld-wrapper resolves relative -L directories from the working directory... " >&2
      # gcc joins -L with a relative directory, which ld-wrapper ignores, so
      # pass them to ld separately, as a direct call to ld might.
      checkRelative() {
        (cd "$1" && ${CC} -Wl,-L,"$2" -lfoo -o "$NIX_BUILD_TOP/relative-rpath-check" ${./ldflags-main.c})
        ${READELF} -d relative-rpath-check | grep -F "${fooLib}/lib"
        ${emulator} ./relative-rpath-check
      }
      checkRelative ${fooLib} lib
      checkRelative ${fooLib} ./lib
      checkRelative ${fooLib}/lib .
      checkRelative "$NIX_BUILD_TOP/links" foo-abs
      checkRelative "$NIX_BUILD_TOP/links/sub" foo-rel
    ''}

    echo "Check whether -nostdinc and -nostdinc++ is handled correctly" >&2
    mkdir -p std-include
    cp ${./stdio.h} std-include/stdio.h
    NIX_DEBUG=1 ${CC} -I std-include -nostdinc -o nostdinc-main ${./nostdinc-main.c}
    ${emulator} ./nostdinc-main
    ${CXX} -I std-include -nostdinc++ -o nostdinc-main++ ${./nostdinc-main.c}
    ${emulator} ./nostdinc-main++

    ${lib.optionalString sanitizersWorking ''
      echo "checking whether sanitizers are fully functional... ">&2
      ${CC} -o sanitizers -fsanitize=address,undefined ${./sanitizers.c}
      ASAN_OPTIONS=use_sigaltstack=0 ${emulator} ./sanitizers
    ''}

    echo "Check whether CC and LD with NIX_X_USE_RESPONSE_FILE hardcodes all required binaries..." >&2
    NIX_CC_USE_RESPONSE_FILE=1 NIX_LD_USE_RESPONSE_FILE=1 ${CC} -v

    touch $out
  '';

  meta.platforms = lib.platforms.all;
}
