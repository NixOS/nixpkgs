{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.18.2";
  sha256 = "0b8hkb2sfacmpi3rwr62myn4kfpwbfdlv9k0vnhk3wvl1v4wf29l";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://projects.haskell.org/cpphs/";
    description = "A liberalised re-implementation of cpp, the C pre-processor";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
