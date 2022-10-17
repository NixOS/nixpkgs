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
  version = "0.2.0.4";

  src = fetchFromGitHub {
    owner = "Synthetica9";
    repo = "nix-linter";
    rev = "ecdd50750fd3ffaff83c0637474b884a0c38f8b9";
    sha256 = "0hm6iaamh1wlvqk8z4yfh4idgbclbsimxhlgflwz2hnv9mm12sf1";
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
