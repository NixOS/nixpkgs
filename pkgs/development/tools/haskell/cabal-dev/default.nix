{ cabal, Cabal, cabalInstall, filepath, HTTP, mtl, network, setenv
, tar, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "cabal-dev";
  version = "0.9.2";
  sha256 = "1372bpn8s7d7nm01ggp3m98ldrynidbchk3p14yrjysvxwr3l6q8";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    Cabal filepath HTTP mtl network setenv tar transformers zlib
  ];
  buildTools = [ cabalInstall ];
  meta = {
    homepage = "http://github.com/creswick/cabal-dev";
    description = "Manage sandboxed Haskell build environments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
