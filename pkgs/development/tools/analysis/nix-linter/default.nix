{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
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
    # raise upper bound on hnix https://github.com/Synthetica9/nix-linter/pull/46
    (fetchpatch {
      url = "https://github.com/Synthetica9/nix-linter/commit/b406024e525977b3c69d78d6a94a683e2ded121f.patch";
      sha256 = "0viwbprslcmy70bxy3v27did79nqhlc0jcx4kp0lycswaccvnp1j";
    })
  ];

  description = "Linter for Nix(pkgs), based on hnix";
  homepage = "https://github.com/Synthetica9/nix-linter";
  license = lib.licenses.bsd3;
  maintainers = [ lib.maintainers.marsam ];
}
