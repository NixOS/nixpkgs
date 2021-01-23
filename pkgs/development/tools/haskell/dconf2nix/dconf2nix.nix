{ mkDerivation, base, containers, fetchgit, hedgehog
, optparse-applicative, parsec, lib, stdenv, template-haskell, text
}:
mkDerivation {
  pname = "dconf2nix";
  version = "0.0.7";
  src = fetchgit {
    url = "https://github.com/gvolpe/dconf2nix.git";
    sha256 = "04p8di1ckv5fkfa61pjg5xp8vcw091lz1kw39lh4w8ks2zjwaha1";
    rev = "34c523e920b79208c3b4c0ad371900b0948799f7";
    fetchSubmodules = true;
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
