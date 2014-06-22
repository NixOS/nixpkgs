{ cabal, alex, Cabal, filepath, ghcPaths, happy, xhtml, makeWrapper }:

cabal.mkDerivation (self: {
  pname = "haddock";
  version = "2.10.0";
  sha256 = "045lmmna5nwj07si81vxms5xkkmqvjsiif20nny5mvlabshxn1yi";
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
