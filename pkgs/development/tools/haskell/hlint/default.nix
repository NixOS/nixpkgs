{ cabal, cpphs, filepath, haskellSrcExts, hscolour, transformers
, uniplate
}:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.26";
  sha256 = "001id2853bkxnbh7jc0bvfyq7v9595zn31n7hhma3il0dqim71lp";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cpphs filepath haskellSrcExts hscolour transformers uniplate
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/hlint/";
    description = "Source code suggestions";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
