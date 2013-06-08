{ cabal, Cabal, filepath, HTTP, mtl, network, random, time, zlib }:

cabal.mkDerivation (self: {
  pname = "cabal-install";
  version = "1.16.0.2";
  sha256 = "162nbkkffpbalg368m5s49jrvg9nibdwlwj0j1b8wriyyg4srpv6";
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
