{ lib, stdenv, stdenvNoCC, fetchFromGitHub, callPackage, makeWrapper
<<<<<<< HEAD
, clang, llvm, gcc, which, libcgroup, python3, perl, gmp
, file, wine ? null
, cmocka
, llvmPackages
=======
, clang, llvm, gcc, which, libcgroup, python, perl, gmp
, file, wine ? null, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

# wine fuzzing is only known to work for win32 binaries, and using a mixture of
# 32 and 64-bit libraries ... complicates things, so it's recommended to build
# a full 32bit version of this package if you want to do wine fuzzing
assert (wine != null) -> (stdenv.targetPlatform.system == "i686-linux");

let
<<<<<<< HEAD
  aflplusplus-qemu = callPackage ./qemu.nix { };
=======
  aflplusplus-qemu = callPackage ./qemu.nix { inherit aflplusplus; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  qemu-exe-name = if stdenv.targetPlatform.system == "x86_64-linux" then "qemu-x86_64"
    else if stdenv.targetPlatform.system == "i686-linux" then "qemu-i386"
    else throw "aflplusplus: no support for ${stdenv.targetPlatform.system}!";
  libdislocator = callPackage ./libdislocator.nix { inherit aflplusplus; };
  libtokencap = callPackage ./libtokencap.nix { inherit aflplusplus; };
  aflplusplus = stdenvNoCC.mkDerivation rec {
    pname = "aflplusplus";
<<<<<<< HEAD
    version = "4.06c";
=======
    version = "2.65c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    src = fetchFromGitHub {
      owner = "AFLplusplus";
      repo = "AFLplusplus";
      rev = version;
<<<<<<< HEAD
      sha256 = "sha256-Gb1nYDBnwLS+m8e1UD0WLIrnp8KRgliGQVvQD22JXrQ=";
=======
      sha256 = "1np2a3kypb2m8nyv6qnij18yzn41pl8619jzydci40br4vxial9l";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
    enableParallelBuilding = true;

    # Note: libcgroup isn't needed for building, just for the afl-cgroup
    # script.
    nativeBuildInputs = [ makeWrapper which clang gcc ];
<<<<<<< HEAD
    buildInputs = [ llvm python3 gmp llvmPackages.bintools ]
      ++ lib.optional (wine != null) python3.pkgs.wrapPython;

    # Flag is already set by package and causes some compiler warnings.
    # warning: "_FORTIFY_SOURCE" redefined
    hardeningDisable = [ "fortify" ];

    postPatch = ''
      # Don't care about this.
      rm Android.bp

      # Replace the CLANG_BIN variables with the correct path.
      # Replace "gcc" and friends with full paths in afl-gcc.
      # Prevents afl-gcc picking up any (possibly incorrect) gcc from the path.
      # Replace LLVM_BINDIR with a non-existing path to give a hard error when it's used.
      substituteInPlace src/afl-cc.c \
        --replace "CLANGPP_BIN" '"${clang}/bin/clang++"' \
        --replace "CLANG_BIN" '"${clang}/bin/clang"' \
        --replace '"gcc"' '"${gcc}/bin/gcc"' \
        --replace '"g++"' '"${gcc}/bin/g++"' \
        --replace 'getenv("AFL_PATH")' "(getenv(\"AFL_PATH\") ? getenv(\"AFL_PATH\") : \"$out/lib/afl\")"

      substituteInPlace src/afl-ld-lto.c \
        --replace 'LLVM_BINDIR' '"/nixpkgs-patched-does-not-exist"'

      # Remove the rest of the line
      sed -i 's|LLVM_BINDIR = .*|LLVM_BINDIR = |' utils/aflpp_driver/GNUmakefile
      substituteInPlace utils/aflpp_driver/GNUmakefile \
        --replace 'LLVM_BINDIR = ' 'LLVM_BINDIR = ${clang}/bin/'

      substituteInPlace GNUmakefile.llvm \
        --replace "\$(LLVM_BINDIR)/clang" "${clang}/bin/clang"
=======
    buildInputs = [ llvm python gmp ]
      ++ lib.optional (wine != null) python.pkgs.wrapPython;


    postPatch = ''
      # Replace the CLANG_BIN variables with the correct path
      substituteInPlace llvm_mode/afl-clang-fast.c \
        --replace "CLANGPP_BIN" '"${clang}/bin/clang++"' \
        --replace "CLANG_BIN" '"${clang}/bin/clang"' \
        --replace 'getenv("AFL_PATH")' "(getenv(\"AFL_PATH\") ? getenv(\"AFL_PATH\") : \"$out/lib/afl\")"

      # Replace "gcc" and friends with full paths in afl-gcc
      # Prevents afl-gcc picking up any (possibly incorrect) gcc from the path
      substituteInPlace src/afl-gcc.c \
        --replace '"gcc"' '"${gcc}/bin/gcc"' \
        --replace '"g++"' '"${gcc}/bin/g++"' \
        --replace '"gcj"' '"gcj-UNSUPPORTED"' \
        --replace '"clang"' '"clang-UNSUPPORTED"' \
        --replace '"clang++"' '"clang++-UNSUPPORTED"'
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    '';

    env.NIX_CFLAGS_COMPILE = toString [
      # Needed with GCC 12
      "-Wno-error=use-after-free"
    ];

<<<<<<< HEAD
    makeFlags = [
      "PREFIX=$(out)"
      "USE_BINDIR=0"
    ];
    buildPhase = ''
      runHook preBuild

      common="$makeFlags -j$NIX_BUILD_CORES"
      make distrib $common
      make -C qemu_mode/libcompcov $common
      make -C qemu_mode/unsigaction $common

      runHook postBuild
=======
    makeFlags = [ "PREFIX=$(out)" ];
    buildPhase = ''
      common="$makeFlags -j$NIX_BUILD_CORES"
      make all $common
      make radamsa $common
      make -C gcc_plugin CC=${gcc}/bin/gcc CXX=${gcc}/bin/g++ $common
      make -C llvm_mode $common
      make -C qemu_mode/libcompcov $common
      make -C qemu_mode/unsigaction $common
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    '';

    postInstall = ''
      # remove afl-clang(++) which are just symlinks to afl-clang-fast
      rm $out/bin/afl-clang $out/bin/afl-clang++

      # the makefile neglects to install unsigaction
      cp qemu_mode/unsigaction/unsigaction*.so $out/lib/afl/

      # Install the custom QEMU emulator for binary blob fuzzing.
<<<<<<< HEAD
      ln -s ${aflplusplus-qemu}/bin/${qemu-exe-name} $out/bin/afl-qemu-trace
=======
      cp ${aflplusplus-qemu}/bin/${qemu-exe-name} $out/bin/afl-qemu-trace
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      # give user a convenient way of accessing libcompconv.so, libdislocator.so, libtokencap.so
      cat > $out/bin/get-afl-qemu-libcompcov-so <<END
      #!${stdenv.shell}
      echo $out/lib/afl/libcompcov.so
      END
      chmod +x $out/bin/get-afl-qemu-libcompcov-so
<<<<<<< HEAD
      ln -s ${libdislocator}/bin/get-libdislocator-so $out/bin/
      ln -s ${libtokencap}/bin/get-libtokencap-so $out/bin/

      # Install the cgroups wrapper for asan-based fuzzing.
      cp utils/asan_cgroups/limit_memory.sh $out/bin/afl-cgroup
=======
      cp ${libdislocator}/bin/get-libdislocator-so $out/bin/
      cp ${libtokencap}/bin/get-libtokencap-so $out/bin/

      # Install the cgroups wrapper for asan-based fuzzing.
      cp examples/asan_cgroups/limit_memory.sh $out/bin/afl-cgroup
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      chmod +x $out/bin/afl-cgroup
      substituteInPlace $out/bin/afl-cgroup \
        --replace "cgcreate" "${libcgroup}/bin/cgcreate" \
        --replace "cgexec"   "${libcgroup}/bin/cgexec" \
        --replace "cgdelete" "${libcgroup}/bin/cgdelete"

      patchShebangs $out/bin

    '' + lib.optionalString (wine != null) ''
      substitute afl-wine-trace $out/bin/afl-wine-trace \
        --replace "qemu_mode/unsigaction" "$out/lib/afl"
      chmod +x $out/bin/afl-wine-trace

      # qemu needs to be fed ELFs, not wrapper scripts, so we have to cheat a bit if we
      # detect a wrapped wine
      for winePath in ${wine}/bin/.wine ${wine}/bin/wine; do
        if [ -x $winePath ]; then break; fi
      done
      makeWrapperArgs="--set-default 'AFL_WINE_PATH' '$winePath'" \
<<<<<<< HEAD
        wrapPythonProgramsIn $out/bin ${python3.pkgs.pefile}
    '';

    nativeInstallCheckInputs = [ perl file cmocka ];
    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck

      # replace references to tools in build directory with references to installed locations
      substituteInPlace test/test-qemu-mode.sh \
        --replace '../libcompcov.so' '`$out/bin/get-afl-qemu-libcompcov-so`' \
        --replace '../afl-qemu-trace' '$out/bin/afl-qemu-trace' \
        --replace '../afl-fuzz' '$out/bin/afl-fuzz' \
        --replace '../qemu_mode/unsigaction/unsigaction32.so' '$out/lib/afl/unsigaction32.so' \
        --replace '../qemu_mode/unsigaction/unsigaction64.so' '$out/lib/afl/unsigaction64.so'

      substituteInPlace test/test-libextensions.sh \
        --replace '../libdislocator.so' '`$out/bin/get-libdislocator-so`' \
        --replace '../libtokencap.so' '`$out/bin/get-libtokencap-so`'
      substituteInPlace test/test-llvm.sh \
        --replace '../afl-cmin.bash' '`$out/bin/afl-cmin.bash`'
      # perl -pi -e 's|(?<!\.)(?<!-I)(\.\./)([^\s\/]+?)(?<!\.c)(?<!\.s?o)(?=\s)|\$out/bin/\2|g' test/test.sh
      patchShebangs .
      cd test && ./test-all.sh

      runHook postInstallCheck
=======
        wrapPythonProgramsIn $out/bin ${python.pkgs.pefile}
    '';

    nativeInstallCheckInputs = [ perl file ];
    doInstallCheck = true;
    installCheckPhase = ''
      # replace references to tools in build directory with references to installed locations
      substituteInPlace test/test.sh \
        --replace '../libcompcov.so' '`$out/bin/get-afl-qemu-libcompcov-so`' \
        --replace '../libdislocator.so' '`$out/bin/get-libdislocator-so`' \
        --replace '../libtokencap.so' '`$out/bin/get-libtokencap-so`'
      perl -pi -e 's|(?<!\.)(?<!-I)(\.\./)([^\s\/]+?)(?<!\.c)(?<!\.s?o)(?=\s)|\$out/bin/\2|g' test/test.sh
      cd test && ./test.sh
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    '';

    passthru = {
      inherit libdislocator libtokencap;
      qemu = aflplusplus-qemu;
    };

    meta = {
      description = ''
        A heavily enhanced version of AFL, incorporating many features
        and improvements from the community
      '';
      homepage    = "https://aflplus.plus";
      license     = lib.licenses.asl20;
      platforms   = ["x86_64-linux" "i686-linux"];
      maintainers = with lib.maintainers; [ ris mindavi ];
    };
  };
in aflplusplus
