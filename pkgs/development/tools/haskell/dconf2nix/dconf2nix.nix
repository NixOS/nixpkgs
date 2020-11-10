{ mkDerivation, base, containers, fetchgit, hedgehog
, optparse-applicative, parsec, stdenv, template-haskell, text
}:
mkDerivation {
  pname = "dconf2nix";
  version = "0.0.6";
  src = fetchgit {
    url = "https://github.com/gvolpe/dconf2nix.git";
    sha256 = "0ql3xrr05kg1xrfxq86mhzh5ky33sngx57sahzck3rb8fv2g6amv";
    rev = "cf976e033c1a89f897924baa219c3b227fe68489";
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
  license = stdenv.lib.licenses.asl20;
}
