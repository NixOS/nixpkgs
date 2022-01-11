{ mkDerivation, base, containers, fetchgit, hedgehog, lib
, optparse-applicative, parsec, template-haskell, text
}:
mkDerivation {
  pname = "dconf2nix";
  version = "0.0.10";
  src = fetchgit {
    url = "https://github.com/gvolpe/dconf2nix.git";
    sha256 = "0ddjgd97nhcbdkry3668mnjb0kbkklzab7zr12km3p8fv99xzva4";
    rev = "629faff2deb6a1131c67e241b688000f859dac48";
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
