{ cabal, async, Cabal, convertible, dataDefault, deepseq, djinnGhc
, doctest, emacs, filepath, ghcPaths, ghcSybUtils, haskellSrcExts
, hlint, hspec, ioChoice, monadControl, monadJournal, mtl, split
, syb, temporary, text, time, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "5.2.1.1";
  sha256 = "09dg54970s4n54xxmalr5a2g4r5jnwccl9984shmmv0vsr3h5k26";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    async Cabal convertible dataDefault deepseq djinnGhc filepath
    ghcPaths ghcSybUtils haskellSrcExts hlint ioChoice monadControl
    monadJournal mtl split syb temporary text time transformers
    transformersBase
  ];
  testDepends = [
    Cabal convertible deepseq djinnGhc doctest filepath ghcPaths
    ghcSybUtils haskellSrcExts hlint hspec ioChoice monadControl
    monadJournal mtl split syb temporary text time transformers
    transformersBase
  ];
  buildTools = [ emacs ];
  postInstall = ''
    cd $out/share/$pname-$version
    make
    rm Makefile
    cd ..
    ensureDir "$out/share/emacs"
    mv $pname-$version emacs/site-lisp
    mv $out/bin/ghc-mod $out/bin/.ghc-mod-wrapped
    cat - > $out/bin/ghc-mod <<EOF
    #! ${self.stdenv.shell}
    COMMAND=\$1
    shift
    eval exec $out/bin/.ghc-mod-wrapped \$COMMAND \$( ${self.ghc.GHCGetPackages} ${self.ghc.version} | tr " " "\n" | tail -n +2 | paste -d " " - - | sed 's/.*/-g "&"/' | tr "\n" " ") "\$@"
    EOF
    chmod +x $out/bin/ghc-mod
  '';
  meta = {
    homepage = "http://www.mew.org/~kazu/proj/ghc-mod/";
    description = "Happy Haskell Programming";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
