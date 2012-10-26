{ cabal, Cabal, filepath, HTTP, mtl, network, random, time, zlib }:

cabal.mkDerivation (self: {
  pname = "cabal-install";
  version = "1.16.0.1";
  sha256 = "0w9fs3r82ipw0ya95az2y8fqg0c9lkfx6z7q89lp4qhwy2l3g0d3";
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
