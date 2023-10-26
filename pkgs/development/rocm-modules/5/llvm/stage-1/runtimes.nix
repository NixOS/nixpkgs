{ lib
, callPackage
, rocmUpdateScript
, llvm
}:

callPackage ../base.nix rec {
  inherit rocmUpdateScript;
  buildDocs = false;
  buildMan = false;
  buildTests = false;
  targetName = "runtimes";
  targetDir = targetName;

  targetRuntimes = [
    "libunwind"
    "libcxxabi"
    "libcxx"
    "compiler-rt"
  ];

  extraBuildInputs = [ llvm ];

  extraCMakeFlags = [
    "-DLIBCXX_INCLUDE_BENCHMARKS=OFF"
    "-DLIBCXX_CXX_ABI=libcxxabi"
  ];

  extraLicenses = [ lib.licenses.mit ];
}
