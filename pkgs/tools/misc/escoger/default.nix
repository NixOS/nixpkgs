{ cabal, dataDefault, fetchFromGitHub, HUnit, mtl, parallel
, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, vector, vectorAlgorithms, vty
}:

let
  rv = "b6b11c51846a9283ef4ee7c839b99ded9f6c3bc8";
in
cabal.mkDerivation (self: {
  pname = "escoger";
  version = "0.1.0.0-${rv}";
  src = fetchFromGitHub {
    owner = "tstat";
    repo = "escoger";
    rev = rv;
    sha256 = "0n6mvg5cm50ym20bz74b7q1afkljp0fc9pxhqk0ai82a71xxbxy3";
  };
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    dataDefault mtl parallel vector vectorAlgorithms vty
  ];
  testDepends = [
    dataDefault HUnit mtl parallel QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2 vector vectorAlgorithms
    vty
  ];
  meta = {
    description = "A multithreaded terminal fuzzy selector";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
