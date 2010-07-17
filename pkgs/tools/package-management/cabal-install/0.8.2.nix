{cabal, HTTP, network, zlib} :

cabal.mkDerivation (self : {
  pname = "cabal-install";
  name = self.fname;
  version = "0.8.2"; # Haskell Platform 2010.2.0.0
  sha256 = "8f896ab46ec6c578f620ce4150f7cd04a2088be793113b33cc570b13b6b86e0b";
  extraBuildInputs = [HTTP network zlib];

  meta = {
    description = "The command-line interface for Cabal and Hackage";
  };
})
