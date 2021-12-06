{ mkDerivation, base, containers, fetchgit, hedgehog, lib
, optparse-applicative, parsec, template-haskell, text
}:
mkDerivation {
  pname = "dconf2nix";
  version = "0.0.8";
  src = fetchgit {
    url = "https://github.com/gvolpe/dconf2nix.git";
    sha256 = "0svckx9xwfz0idy7wav0hmh5n0vnc63dysg46w7mpm8r7rdxxk8q";
    rev = "7aea3b548f446702897c04cb6766448ca31b609b";
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
