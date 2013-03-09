{ cabal, fetchurl, Cabal, cabalInstall, filepath, HTTP, mtl, network, tar
, transformers, zlib, setenv
}:

cabal.mkDerivation (self: {
  pname = "cabal-dev";
  version = "0.9.1-git";
  src = fetchurl {
    url = "https://github.com/creswick/cabal-dev/archive/54e7d93d5b309c56192c146c7a807ac3591bc464.tar.gz";
    sha256 = "1isi02jik0vrg48l7r2mj4cf9ms6hpxxz1mmhl7s3kkxx775cxj9";
    name = "${self.name}.tar.gz";
  };
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    Cabal filepath HTTP mtl network tar transformers zlib setenv
  ];
  buildTools = [ cabalInstall ];
  meta = {
    homepage = "http://github.com/creswick/cabal-dev";
    description = "Manage sandboxed Haskell build environments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
