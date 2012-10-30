{ cabal, Cabal, cabalInstall, filepath, HTTP, mtl, network, tar
, transformers, zlib
}:

cabal.mkDerivation (self: {
  pname = "cabal-dev";
  version = "0.9.1";
  sha256 = "1brz0nw959jdyjrhjqy9sixsb316hjmw4pxxsybfl8vixsivdfh6";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    Cabal filepath HTTP mtl network tar transformers zlib
  ];
  buildTools = [ cabalInstall ];
  meta = {
    homepage = "http://github.com/creswick/cabal-dev";
    description = "Manage sandboxed Haskell build environments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
