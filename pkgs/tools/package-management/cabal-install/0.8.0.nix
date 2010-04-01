{cabal, HTTP, network, zlib} :

cabal.mkDerivation (self : {
  pname = "cabal-install";
  name = self.fname;
  version = "0.8.0"; # Haskell Platform 2010.1.0.0
  sha256 = "6d16618ff454f8d732cad64a53b767b5b6bb95ba4970b260a40e8f467035493c";
  extraBuildInputs = [HTTP network zlib];

  meta = {
    description = "The command-line interface for Cabal and Hackage";
  };
})
