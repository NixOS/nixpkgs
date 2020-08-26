{ stdenv, fetchFromGitHub, callPackage, makeWrapper
, clang, llvm, libbfd, libopcodes, libunwind, libblocksruntime
}:

let
  honggfuzz = stdenv.mkDerivation rec {
    pname = "honggfuzz";
    version = "2.2";

    src = fetchFromGitHub {
      owner = "google";
      repo = pname;
      rev = "${version}";
      sha256 = "0ycpx087mhv5s7w01chg2b6rfb3zgfpp9in0x73kpv7y4dcvg7gw";
    };
    enableParallelBuilding = true;

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ llvm ];
    propagatedBuildInputs = [ libbfd libopcodes libunwind libblocksruntime ];

    makeFlags = [ "PREFIX=$(out)" ];

    meta = {
      description = "A security oriented, feedback-driven, evolutionary, easy-to-use fuzzer";
      longDescription = ''
        Honggfuzz is a security oriented, feedback-driven, evolutionary,
        easy-to-use fuzzer with interesting analysis options. It is
        multi-process and multi-threaded, blazingly fast when the persistent
        fuzzing mode is used and has a solid track record of uncovered security
        bugs.

        Honggfuzz uses low-level interfaces to monitor processes and it will
        discover and report hijacked/ignored signals from crashes. Feed it
        a simple corpus directory (can even be empty for the feedback-driven
        fuzzing), and it will work its way up, expanding it by utilizing
        feedback-based coverage metrics.
      '';
      homepage    = "https://honggfuzz.dev/";
      license     = stdenv.lib.licenses.asl20;
      platforms   = ["x86_64-linux"];
      maintainers = with stdenv.lib.maintainers; [ cpu ];
    };
  };
in honggfuzz
