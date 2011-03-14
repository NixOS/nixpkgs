{cabal, mtl, perl}:

cabal.mkDerivation (self : {
  pname = "happy";
  version = "1.18.4"; # Haskell Platform 2009.2.0.1
  name = self.fname;
  sha256 = "909bec4541a92d3765e74756f752514d2d03ec7a5d3e74c18268a57fe7ffa832";
  extraBuildInputs = [perl];
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Happy is a parser generator for Haskell";
  };
})
