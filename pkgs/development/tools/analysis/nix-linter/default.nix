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
, fetchpatch
}:

mkDerivation rec {
  pname = "nix-linter-unstable";
  version = "2020-09-25";

  src = fetchFromGitHub {
    owner = "Synthetica9";
    repo = "nix-linter";
    rev = "2516a8cda41f9bb553a1c3eca38e3dd94ebf53de";
    sha256 = "07mn2c9v67wsm57jlxv9pqac9hahw4618vngmj2sfbgihx8997kb";
  };

  isLibrary = false;
  isExecutable = true;
  libraryHaskellDepends = [ fixplate ];
  executableHaskellDepends = [ streamly mtl path pretty-terminal text base aeson cmdargs containers hnix bytestring path-io ];
  testHaskellDepends = [ tasty tasty-hunit tasty-th ];

  patches = [
    # Fix compatibility with hnix≥0.13.0 https://github.com/Synthetica9/nix-linter/pull/51
    (fetchpatch {
      url = "https://github.com/Synthetica9/nix-linter/commit/f73acacd8623dc25c9a35f8e04e4ff33cc596af8.patch";
      sha256 = "139fm21hdg3vcw8hv35kxj4awd52bjqbb76mpzx191hzi9plj8qc";
    })
  ];

  description = "Linter for Nix(pkgs), based on hnix";
  homepage = "https://github.com/Synthetica9/nix-linter";
  license = lib.licenses.bsd3;
  maintainers = [ lib.maintainers.marsam ];
}
