{ mkDerivation, base, containers, fetchgit, hedgehog, lib
, optparse-applicative, parsec, template-haskell, text
}:
mkDerivation {
  pname = "dconf2nix";
  version = "0.0.8";
  src = fetchgit {
    url = "https://github.com/gvolpe/dconf2nix.git";
    sha256 = "19jk3p0ys3lbqk21lm37a7alkg2vhnmkvcffjqfxrw8p4737hxid";
    rev = "6bf3d7d4ca9f553a9e1ba4a70a65640114d230b2";
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
