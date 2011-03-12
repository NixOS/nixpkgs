{cabal, HTTP, network, zlib} :

cabal.mkDerivation (self : {
  pname = "cabal-install";
  name = self.fname;
  version = "0.10.2"; # Haskell Platform 2011.2.0.0
  sha256 = "05gmgxdlymp66c87szx1vq6hlraispdh6pm0n85s74yihjwwhmv3";
  extraBuildInputs = [HTTP network zlib];

  meta = {
    description = "The command-line interface for Cabal and Hackage";
  };
})
