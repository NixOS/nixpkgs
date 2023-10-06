{ mkDerivation, base, containers, emojis, fetchgit, hedgehog, lib
, optparse-applicative, parsec, template-haskell, text
}:
mkDerivation {
  pname = "dconf2nix";
  version = "0.0.12";
  src = fetchgit {
    url = "https://github.com/gvolpe/dconf2nix.git";
    sha256 = "0cy47g6ksxf7p0qnzljg0c5dv65r79krkzw6iasivv8czc2lv8sc";
    rev = "101e102c6a3aa79d1787e2ae77fa3379153d29f8";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base containers emojis optparse-applicative parsec text
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base containers hedgehog parsec template-haskell text
  ];
  description = "Convert dconf files to Nix, as expected by Home Manager";
  license = lib.licenses.asl20;
  mainProgram = "dconf2nix";
}
