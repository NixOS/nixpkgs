{ cabal, Cabal, filepath, HTTP, mtl, network, random, time, zlib }:

cabal.mkDerivation (self: {
  pname = "cabal-install";
  version = "0.14.0";
  sha256 = "1n2vvlmfgfrj3z4ag5bj278vmdh6fw7xb0ixbxxxcngzd41bbwpl";
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
