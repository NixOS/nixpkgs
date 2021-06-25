{ lib
, mkDerivation
, fetchFromGitHub
, fixplate
, tasty
, tasty-hunit
, tasty-th
, streamly
, mtl
, path
, pretty-terminal
, text
, base
, aeson
, path-io
, cmdargs
, containers
, hnix
, bytestring
}:

mkDerivation rec {
  pname = "nix-linter-unstable";
  version = "2021-06-16";

  src = fetchFromGitHub {
    owner = "Synthetica9";
    repo = "nix-linter";
    rev = "74707ed48dcc58dbfa27ae25ee0e044c072cc344";
    sha256 = "17scghkinpx3pzlw3hw023ybnd8cy7bqfy8b48vwaq8a7bnm2rs3";
  };

  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [ fixplate ];
  executableHaskellDepends = [ streamly mtl path pretty-terminal text base aeson cmdargs containers hnix bytestring path-io ];
  testHaskellDepends = [ tasty tasty-hunit tasty-th ];

  description = "Linter for Nix(pkgs), based on hnix";
  homepage = "https://github.com/Synthetica9/nix-linter";
  license = lib.licenses.bsd3;
  maintainers = [ lib.maintainers.marsam ];
}
