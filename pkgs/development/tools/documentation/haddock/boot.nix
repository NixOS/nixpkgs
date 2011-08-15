{cabal, gmp}:

cabal.mkDerivation (self : {
  pname = "haddock";
  version = "0.9";
  name = self.fname;
  sha256 = "beefd4a6da577978e7a79cabba60970accc5cd48fbb04c424a6b36ace3a9f8d0";
  extraBuildInputs = [gmp];

  # we are using this for booting, and ghc-6.4.2 doesn't have full
  # Cabal support, therefore we have to override some things:
  configurePhase = ''
    sed -i -e 's|cabal-version:.*$|cabal-version: >= 1.0|' \
           -e '/^flag/,+3d' \
           -e '/^ *if/,+2d' \
           -e '/^ *else/d' \
           -e 's|^    ||' \
           -e 's|^  ||' \
           -e '/^executable/,$ { /^ *$/d }' \
           -e '/^build-depends/d' \
           -e '/data-files/ibuild-depends: base, haskell98' \
           haddock.cabal
    cp dist/build/haddock/haddock-tmp/*.hs src
    ghc --make -o Setup Setup.lhs
    ./Setup configure --verbose --prefix="$out"
  '';

  installPhase = ''
    ./Setup copy
  '';

  meta = {
    homepage = "http://www.haskell.org/haddock/";
    description = "Haddock is a documentation-generation tool for Haskell libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
