{ stdenv, stdenvNoCC, fetchFromGitHub, callPackage, makeWrapper
, clang, llvm, gcc, which, libcgroup, python, perl, gmp
, file, wine ? null, fetchpatch, cmocka
}:

# wine fuzzing is only known to work for win32 binaries, and using a mixture of
# 32 and 64-bit libraries ... complicates things, so it's recommended to build
# a full 32bit version of this package if you want to do wine fuzzing
assert (wine != null) -> (stdenv.targetPlatform.system == "i686-linux");

let
  aflplusplus-qemu = callPackage ./qemu.nix { inherit aflplusplus; };
  qemu-exe-name = if stdenv.targetPlatform.system == "x86_64-linux" then "qemu-x86_64"
    else if stdenv.targetPlatform.system == "i686-linux" then "qemu-i386"
    else throw "aflplusplus: no support for ${stdenv.targetPlatform.system}!";
  libdislocator = callPackage ./libdislocator.nix { inherit aflplusplus; };
  libtokencap = callPackage ./libtokencap.nix { inherit aflplusplus; };
  aflplusplus = stdenvNoCC.mkDerivation rec {
    pname = "aflplusplus";
    version = "2.66c";

    src = fetchFromGitHub {
      owner = "AFLplusplus";
      repo = "AFLplusplus";
      rev = version;
      sha256 = "0nsr61lmhwg0zn7kn98ifc20y9w19p857gl414c226cz4v0dl53g";
    };
    enableParallelBuilding = true;

    # Note: libcgroup isn't needed for building, just for the afl-cgroup
    # script.
    nativeBuildInputs = [ makeWrapper which clang gcc ];
    buildInputs = [ llvm python gmp ]
      ++ stdenv.lib.optional (wine != null) python.pkgs.wrapPython;

    patches = [
      (fetchpatch {
        # patch that prevents an error during execution of the unit tests (unicornafl is tested while it's not built)
        # see https://github.com/AFLplusplus/AFLplusplus/issues/487 for upstream discussion
        url = "https://github.com/AFLplusplus/AFLplusplus/commit/cc74efa35e190d15533f99a5a99b698e772fbe81.patch";
        sha256 = "174q51m094jil9pr8rjnkfrnf5p6lvmdmdnrnfgbhkv18bgr8p23";
      })
    ];

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
    '';

    makeFlags = [ "PREFIX=$(out)" ];
    buildPhase = ''
      common="$makeFlags -j$NIX_BUILD_CORES"
      make all $common
      make -C gcc_plugin CC=${gcc}/bin/gcc CXX=${gcc}/bin/g++ $common
      make -C llvm_mode $common
      make -C qemu_mode/libcompcov $common
      make -C qemu_mode/unsigaction $common
    '';

    postInstall = ''
      # remove afl-clang(++) which are just symlinks to afl-clang-fast
      rm $out/bin/afl-clang $out/bin/afl-clang++

      # the makefile neglects to install unsigaction
      cp qemu_mode/unsigaction/unsigaction*.so $out/lib/afl/

      # Install the custom QEMU emulator for binary blob fuzzing.
      cp ${aflplusplus-qemu}/bin/${qemu-exe-name} $out/bin/afl-qemu-trace

      # give user a convenient way of accessing libcompconv.so, libdislocator.so, libtokencap.so
      cat > $out/bin/get-afl-qemu-libcompcov-so <<END
      #!${stdenv.shell}
      echo $out/lib/afl/libcompcov.so
      END
      chmod +x $out/bin/get-afl-qemu-libcompcov-so
      cp ${libdislocator}/bin/get-libdislocator-so $out/bin/
      cp ${libtokencap}/bin/get-libtokencap-so $out/bin/

      # Install the cgroups wrapper for asan-based fuzzing.
      cp examples/asan_cgroups/limit_memory.sh $out/bin/afl-cgroup
      chmod +x $out/bin/afl-cgroup
      substituteInPlace $out/bin/afl-cgroup \
        --replace "cgcreate" "${libcgroup}/bin/cgcreate" \
        --replace "cgexec"   "${libcgroup}/bin/cgexec" \
        --replace "cgdelete" "${libcgroup}/bin/cgdelete"

      patchShebangs $out/bin

    '' + stdenv.lib.optionalString (wine != null) ''
      substitute afl-wine-trace $out/bin/afl-wine-trace \
        --replace "qemu_mode/unsigaction" "$out/lib/afl"
      chmod +x $out/bin/afl-wine-trace

      # qemu needs to be fed ELFs, not wrapper scripts, so we have to cheat a bit if we
      # detect a wrapped wine
      for winePath in ${wine}/bin/.wine ${wine}/bin/wine; do
        if [ -x $winePath ]; then break; fi
      done
      makeWrapperArgs="--set-default 'AFL_WINE_PATH' '$winePath'" \
        wrapPythonProgramsIn $out/bin ${python.pkgs.pefile}
    '';

    installCheckInputs = [ perl file python.pkgs.setuptools cmocka ];
    doInstallCheck = true;
    installCheckPhase = ''
      # replace references to tools in build directory with references to installed locations
      substituteInPlace test/test.sh \
        --replace '../libcompcov.so' '`$out/bin/get-afl-qemu-libcompcov-so`' \
        --replace '../libdislocator.so' '`$out/bin/get-libdislocator-so`' \
        --replace '../libtokencap.so' '`$out/bin/get-libtokencap-so`'
      # replace all occurences of relative paths (e.g. ../afl-fuzz) with $out/bin/afl-fuzz
      # only works for a single path up
      perl -pi -e 's|(?<!\.)(?<!-I)(\.\./)([^\s\/]+?)(?<!\.c)(?<!\.s?o)(?=\s)|\$out/bin/\2|g' test/test.sh
      cd test && ./test.sh
    '';

    passthru = {
      inherit libdislocator libtokencap;
      qemu = aflplusplus-qemu;
    };

    meta = {
      description = ''
        AFL++ is a heavily enhanced version of AFL, incorporating many features and
        improvements from the community.
      '';
      homepage    = "https://aflplus.plus";
      license     = stdenv.lib.licenses.asl20;
      platforms   = ["x86_64-linux" "i686-linux"];
      maintainers = with stdenv.lib.maintainers; [ ris mindavi ];
    };
  };
in aflplusplus
