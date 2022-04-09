{ mkDerivation, base, containers, fetchFromGitHub, hedgehog, lib
, optparse-applicative, parsec, template-haskell, text
}:
mkDerivation {
  pname = "dconf2nix";
  version = "0.0.11";
  src = fetchFromGitHub {
    owner = "gvolpe";
    repo = "dconf2nix";
    rev = "fe7e3d973caa87b1b706096aff3d670f65e39fda";
    sha256 = "sha256-zuhiFVA8LvFKOPMMvqFu+ofv0CrIl2pMZbPQE/tCaM8=";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base containers optparse-applicative parsec text
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base containers hedgehog parsec template-haskell text
  ];
  description = "Convert dconf files to Nix, as expected by Home Manager";
  license = lib.licenses.asl20;
}
