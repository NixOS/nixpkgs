{ stdenv, stdenvNoCC, fetchFromGitHub, makeWrapper, fetchgit
, clang_9, llvm_9, gcc9, which, gmp, python3
}:

let
  aflplusplus = stdenvNoCC.mkDerivation rec {
    pname = "aflplusplus";
    version = "2.64c";

    src = fetchFromGitHub {
      owner = "vanhauser-thc";
      repo = pname;
      rev = "${version}";
      sha256 = "0n618pk6nlmkcbv1qm05fny4mnhcprrw0ppmra1phvk1y22iildj";
    };

    enableParallelBuilding = true;

    nativeBuildInputs = [ makeWrapper which clang_9 gcc9 ];
    # python3 is not fully required, but used for the plugin/custom mutator system.
    buildInputs = [ llvm_9 gmp python3 ];

    makeFlags = [ "PREFIX=$(out)" ];
    # Only build the source-code fuzzers here for now.
    buildPhase = ''
      make source-only $makeFlags -j$NIX_BUILD_CORES
    '';

    checkPhase = ''
      make tests
    '';

    postInstall = ''
      # Patch shebangs before wrapping
      patchShebangs $out/bin
    '';

    meta = {
      description = "Powerful fuzzer via genetic algorithms and instrumentation";
      longDescription = ''
        AFL++ is a fork of AFL with community patches and improved performance.
        AFL(++) is a fuzzer that can help find bugs in source code written in C or C++.
        It implements guided fuzzing that helps finding testcases for bugs quickly.
      '';
      homepage    = "https://github.com/vanhauser-thc/AFLplusplus";
      license     = stdenv.lib.licenses.asl20;
      platforms   = ["x86_64-linux" "i686-linux"];
      maintainers = with stdenv.lib.maintainers; [ Mindavi ];
    };
  };
in aflplusplus

