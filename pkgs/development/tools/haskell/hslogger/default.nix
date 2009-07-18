{cabal, mtl, network, time}:

cabal.mkDerivation (self : {
  pname = "hslogger";
  version = "1.0.7";
  sha256 = "0fb8aagylrr5z19801szj868apcns8lafc4ydx9v0ka2lbmjqvbz";
  propagatedBuildInputs = [ mtl time network ];
  meta = {
    description = "Versatile logging framework";
  };
})
