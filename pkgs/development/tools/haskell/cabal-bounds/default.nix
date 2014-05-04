{ cabal, Cabal, cmdargs, either, filepath, lens, strict, tasty
, tastyGolden, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "cabal-bounds";
  version = "0.4.1";
  sha256 = "09l9ii26li178sw0rm49w4dhfkf46g4sjjdy4frmc74isvnzkpwj";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal cmdargs either lens strict transformers unorderedContainers
  ];
  testDepends = [ filepath tasty tastyGolden ];
  jailbreak = true;
  doCheck = false;
  postInstall = ''
    mv $out/bin/cabal-bounds $out/bin/.cabal-bounds-wrapped
    cat - > $out/bin/cabal-bounds <<EOF
    #! ${self.stdenv.shell}
    COMMAND=\$1
    shift
    export LD_LIBRARY_PATH=$out/lib/ghc-${self.ghc.version}/${self.pname}-${self.version}
    eval exec $out/bin/.cabal-bounds-wrapped "\$@"
    EOF
    chmod +x $out/bin/cabal-bounds
  '';
  meta = {
    description = "A command line program for managing the bounds/versions of the dependencies in a cabal file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
