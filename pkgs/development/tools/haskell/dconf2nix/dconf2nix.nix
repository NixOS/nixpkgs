{ mkDerivation, base, containers, fetchgit, optparse-applicative
, parsec, stdenv, text
}:
mkDerivation {
  pname = "dconf2nix";
  version = "0.0.5";
  src = fetchgit {
    url = "https://github.com/gvolpe/dconf2nix.git";
    sha256 = "0immbx4bgfq3xmbbrpw441nx0sdpm4cp64s7qbvcbvllp4gbivpg";
    rev = "848ff9966db21c66e61a19c04ab6dfc9270eb78e";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base containers optparse-applicative parsec text
  ];
  executableHaskellDepends = [ base ];
  description = "Convert dconf files to Nix, as expected by Home Manager";
  license = stdenv.lib.licenses.asl20;
}
