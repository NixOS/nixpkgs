{ cabal, alex, Cabal, filepath, ghcPaths, happy, xhtml, makeWrapper }:

cabal.mkDerivation (self: {
  pname = "haddock";
  version = "2.11.0";
  sha256 = "0a29n6y9lmk5w78f6j8s7pg0m0k3wm7bx5r2lhk7bnzkr5f7rkcd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal filepath ghcPaths xhtml makeWrapper ];
  testDepends = [ Cabal filepath ];
  buildTools = [ alex happy ];
  doCheck = false;

  postInstall = ''
   wrapProgram $out/bin/haddock --add-flags "\$(${self.ghc.GHCGetPackages} ${self.ghc.version} \"\$(dirname \$0)\" \"--optghc=-package-conf --optghc=\")"
  '';

  meta = {
    homepage = "http://www.haskell.org/haddock/";
    description = "A documentation-generation tool for Haskell libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
