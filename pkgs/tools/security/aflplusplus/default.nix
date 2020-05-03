{ stdenv, fetchFromGitHub, callPackage, makeWrapper
, clang, llvm, gcc, which, libcgroup, python, perl, gmp
, wine ? null
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
  aflplusplus = stdenv.mkDerivation rec {
    pname = "aflplusplus";
    version = "2.59c";

    src = fetchFromGitHub {
      owner = "vanhauser-thc";
      repo = "AFLplusplus";
      rev = version;
      sha256 = "1ik33ifk4n96762iv1h4kl4jf9yvsq2hgs097wkiy589siw44g5r";
    };
    enableParallelBuilding = true;

    # Note: libcgroup isn't needed for building, just for the afl-cgroup
    # script.
    nativeBuildInputs = [ makeWrapper which ];
    buildInputs = [ llvm python gmp ]
      ++ stdenv.lib.optional (wine != null) python.pkgs.wrapPython;

    makeFlags = [ "PREFIX=$(out)" ];
    buildPhase = ''
      common="$makeFlags -j$NIX_BUILD_CORES"
      make all $common
      make radamsa $common
      make -C gcc_plugin CC=${gcc}/bin/gcc CXX=${gcc}/bin/g++ $common
      make -C llvm_mode $common
      make -C qemu_mode/libcompcov $common
      make -C qemu_mode/unsigaction $common
    '';

    postInstall = ''
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
      cp experimental/asan_cgroups/limit_memory.sh $out/bin/afl-cgroup
      chmod +x $out/bin/afl-cgroup
      substituteInPlace $out/bin/afl-cgroup \
        --replace "cgcreate" "${libcgroup}/bin/cgcreate" \
        --replace "cgexec"   "${libcgroup}/bin/cgexec" \
        --replace "cgdelete" "${libcgroup}/bin/cgdelete"

      # Patch shebangs before wrapping
      patchShebangs $out/bin

      # Wrap afl-clang-fast(++) with a *different* AFL_PATH, because it
      # has totally different semantics in that case(?) - and also set a
      # proper AFL_CC and AFL_CXX so we don't pick up the wrong one out
      # of $PATH.
      # first though we need to replace the afl-clang-fast++ symlink with
      # a real copy to prevent wrapProgram skipping the symlink and confusing
      # nix's cc wrapper
      rm $out/bin/afl-clang-fast++
      cp $out/bin/afl-clang-fast $out/bin/afl-clang-fast++
      for x in $out/bin/afl-clang-fast $out/bin/afl-clang-fast++; do
        wrapProgram $x \
          --set-default AFL_PATH "$out/lib/afl" \
          --run 'export AFL_CC=''${AFL_CC:-${clang}/bin/clang} AFL_CXX=''${AFL_CXX:-${clang}/bin/clang++}'
      done
      # do similar for afl-gcc and afl-gcc-fast
      for x in $out/bin/afl-gcc $out/bin/afl-gcc-fast; do
        wrapProgram $x \
          --set-default AFL_PATH "$out/lib/afl" \
          --run 'export AFL_CC=''${AFL_CC:-${gcc}/bin/gcc} AFL_CXX=''${AFL_CXX:-${gcc}/bin/g++}'
      done
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

    installCheckInputs = [ perl ];
    doInstallCheck = true;
    installCheckPhase = ''
      # replace references to tools in build directory with references to installed locations
      substituteInPlace test/test.sh \
        --replace '`which gcc`' "" \
        --replace '../libcompcov.so' '`$out/bin/get-afl-qemu-libcompcov-so`' \
        --replace '../libdislocator.so' '`$out/bin/get-libdislocator-so`' \
        --replace '../libtokencap.so' '`$out/bin/get-libtokencap-so`'
      perl -pi -e 's|(?<=\s)gcc(?=\s)|${gcc}/bin/gcc|g' test/test.sh
      perl -pi -e 's|(\.\./)(\S+?)(?<!\.c)(?<!\.s?o)(?=\s)|\$out/bin/\2|g' test/test.sh
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
      homepage    = "https://github.com/vanhauser-thc/AFLplusplus";
      license     = stdenv.lib.licenses.asl20;
      platforms   = ["x86_64-linux" "i686-linux"];
      maintainers = with stdenv.lib.maintainers; [ ris ];
    };
  };
in aflplusplus
