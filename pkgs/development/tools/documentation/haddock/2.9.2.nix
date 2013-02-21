{cabal, ghcPaths, xhtml, alex, happy, makeWrapper}:

cabal.mkDerivation (self : {
  pname = "haddock";
  version = "2.9.2"; # Haskell Platform 2011.2.0.0
  name = self.fname;
  sha256 = "189vvp173pqc69zgzqqx6vyhvsc13p1s86ql60rs1j5qlhh8ajg8";
  extraBuildInputs = [alex happy makeWrapper];
  propagatedBuildInputs = [ghcPaths xhtml];

  postInstall = ''
   wrapProgram $out/bin/haddock --add-flags "\$(${self.ghc.GHCGetPackages} ${self.ghc.ghcVersion} \"\$(dirname \$0)\" \"--optghc=-package-conf --optghc=\")"
  '';

  meta = {
    homepage = "http://www.haskell.org/haddock/";
    description = "A documentation-generation tool for Haskell libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
    ];
  };
})
