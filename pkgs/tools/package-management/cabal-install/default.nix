{cabal, HTTP, network, zlib} :

cabal.mkDerivation (self : {
  pname = "cabal-install";
  name = self.fname;
  version = "0.6.2"; # Haskell Platform 2009.0.0
  sha256 = "d8ea91bd0a2a624ab1cf52ddfe48cef02b532bb5e2fcda3fd72ca51efc04b41a";
  extraBuildInputs = [HTTP network zlib];

  meta = {
    description = "The command-line interface for Cabal and Hackage";
  };
})
