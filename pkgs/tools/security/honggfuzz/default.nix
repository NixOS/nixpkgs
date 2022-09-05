{ lib
, stdenv
, fetchFromGitHub
, callPackage
, makeWrapper
, clang
, llvm
# TODO: switch to latest versions when 2.6 release is out to include
#   https://github.com/google/honggfuzz/commit/90fdf81006614664ef05e5e3c6f94d91610f11b2
, libbfd_2_38, libopcodes_2_38
, libunwind
, libblocksruntime }:

stdenv.mkDerivation rec {
  pname = "honggfuzz";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = version;
    sha256 = "sha256-TkyUKmiiSAfCnfQhSOUxuce6+dRyMmHy7vFK59jPIxM=";
  };

  postPatch = ''
    substituteInPlace hfuzz_cc/hfuzz-cc.c \
      --replace '"clang' '"${clang}/bin/clang'
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvm ];
  propagatedBuildInputs = [ libbfd_2_38 libopcodes_2_38 libunwind libblocksruntime ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description =
      "A security oriented, feedback-driven, evolutionary, easy-to-use fuzzer";
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
    homepage = "https://honggfuzz.dev/";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ cpu chivay ];
  };
}
