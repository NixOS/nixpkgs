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
  pname = "nix-linter";
  version = "0.2.0.3";

  src = fetchFromGitHub {
    owner = "Synthetica9";
    repo = "nix-linter";
    rev = "38c4a14681cf3a1e6f098d8b723db503910a28d8";
    sha256 = "16igk4xnm4mg9mw0zg2zk6s44axia3fs6334fasvjy0c7cjwk4c7";
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
