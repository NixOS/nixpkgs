{ cabal, Cabal, filepath, HTTP, mtl, network, random, time, zlib }:

cabal.mkDerivation (self: {
  pname = "cabal-install";
  version = "1.16.0";
  sha256 = "0yg8h028sixvzx42v1spjyx4qfhpsar38cvz9188m62rac8ak8az";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    Cabal filepath HTTP mtl network random time zlib
  ];
  postInstall = ''
    mkdir $out/etc
    mv bash-completion $out/etc/bash_completion.d
  '';
  meta = {
    homepage = "http://www.haskell.org/cabal/";
    description = "The command-line interface for Cabal and Hackage";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
