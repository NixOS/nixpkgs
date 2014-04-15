{ cabal, cmdargs, deepseq, dlist, lens, parallelIo, regexPosix
, systemFileio, systemFilepath, text
}:

cabal.mkDerivation (self: {
  pname = "sizes";
  version = "2.3.1.1";
  sha256 = "1k7rvcj5sp30zwm16wnsw40y4rkqnfxlrl3ridqhp91q8286qjbs";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    cmdargs deepseq dlist lens parallelIo regexPosix systemFileio
    systemFilepath text
  ];
  meta = {
    homepage = "https://github.com/jwiegley/sizes";
    description = "Recursively show space (size and i-nodes) used in subdirectories";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
