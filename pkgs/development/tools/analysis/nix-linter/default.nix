{ lib
, mkDerivation
, fetchFromGitHub
, parallel-io
, fixplate
, pandoc
, tasty
, tasty-hunit
, tasty-th
, streamly
, mtl
, path-io
, path
, pretty-terminal
, text
, base
, aeson
, cmdargs
, containers
, hnix
, bytestring
}:

mkDerivation rec {
  pname = "nix-linter-unstable";
  version = "2019-04-26";

  src = fetchFromGitHub {
    owner = "Synthetica9";
    repo = "nix-linter";
    rev = "4aaf60195cd2d9f9e2345fbdf4aac48e1451292c";
    sha256 = "0c7rcjaxd8z0grwambsw46snv7cg66h3pszw3549z4xz0i60yq87";
  };

  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [ parallel-io fixplate pandoc ];
  executableHaskellDepends = [ streamly mtl path-io path pretty-terminal text base aeson cmdargs containers hnix bytestring ];
  testHaskellDepends = [ tasty tasty-hunit tasty-th ];

  description = "Linter for Nix(pkgs), based on hnix";
  homepage = "https://github.com/Synthetica9/nix-linter";
  license = lib.licenses.bsd3;
  maintainers = [ lib.maintainers.marsam ];
}
