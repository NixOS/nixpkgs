{ cabal, Cabal, filepath, HTTP, network, random, zlib }:

cabal.mkDerivation (self: {
  pname = "cabal-install";
  version = "0.6.2";
  sha256 = "d8ea91bd0a2a624ab1cf52ddfe48cef02b532bb5e2fcda3fd72ca51efc04b41a";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal filepath HTTP network random zlib ];
  meta = {
    homepage = "http://www.haskell.org/cabal/";
    description = "The command-line interface for Cabal and Hackage";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
