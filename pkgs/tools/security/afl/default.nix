{ stdenv, fetchFromGitHub, callPackage, makeWrapper
, clang, llvm, which, libcgroup
}:

let
  afl-qemu = callPackage ./qemu.nix { inherit afl; };
  qemu-exe-name = if stdenv.hostPlatform.system == "x86_64-linux" then "qemu-x86_64"
    else if stdenv.hostPlatform.system == "i686-linux" then "qemu-i386"
    else throw "afl: no support for ${stdenv.hostPlatform.system}!";
  afl = stdenv.mkDerivation rec {
    pname = "afl";
    version = "2.56b";

    src = fetchFromGitHub {
      owner = "google";
      repo = pname;
      rev = "v${version}";
      sha256 = "1q1g59gkm48aa4cg9h70jx4i2gapmypgp5rzs156b2avd95vwkn1";
    };
    enableParallelBuilding = true;

    # Note: libcgroup isn't needed for building, just for the afl-cgroup
    # script.
    nativeBuildInputs = [ makeWrapper which ];
    buildInputs = [ llvm ];

    makeFlags = [ "PREFIX=$(out)" ];
    postBuild = ''
      make -C llvm_mode $makeFlags -j$NIX_BUILD_CORES
    '';
    postInstall = ''
      # Install the custom QEMU emulator for binary blob fuzzing.
      cp ${afl-qemu}/bin/${qemu-exe-name} $out/bin/afl-qemu-trace

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
      for x in $out/bin/afl-clang-fast $out/bin/afl-clang-fast++; do
        wrapProgram $x \
          --prefix AFL_PATH : "$out/lib/afl" \
          --run 'export AFL_CC=''${AFL_CC:-${clang}/bin/clang} AFL_CXX=''${AFL_CXX:-${clang}/bin/clang++}'
      done
    '';

    passthru.qemu = afl-qemu;

    meta = {
      description = "Powerful fuzzer via genetic algorithms and instrumentation";
      longDescription = ''
        American fuzzy lop is a fuzzer that employs a novel type of
        compile-time instrumentation and genetic algorithms to
        automatically discover clean, interesting test cases that
        trigger new internal states in the targeted binary. This
        substantially improves the functional coverage for the fuzzed
        code. The compact synthesized corpora produced by the tool are
        also useful for seeding other, more labor or resource-intensive
        testing regimes down the road.
      '';
      homepage    = "http://lcamtuf.coredump.cx/afl/";
      license     = stdenv.lib.licenses.asl20;
      platforms   = ["x86_64-linux" "i686-linux"];
      maintainers = with stdenv.lib.maintainers; [ thoughtpolice ris ];
    };
  };
in afl
