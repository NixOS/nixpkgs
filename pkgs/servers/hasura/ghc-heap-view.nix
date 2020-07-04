{ mkDerivation, base, binary, bytestring, Cabal, containers
, deepseq, filepath, ghc-heap, stdenv, template-haskell
, transformers
}:
mkDerivation {
  pname = "ghc-heap-view";
  version = "0.6.0";
  sha256 = "99ed6034d02a7a942e1b6ed970e9f7028dcdfd5b5d29fd8a0fb89f1a5e7c5ec8";
  enableSeparateDataOutput = true;
  setupHaskellDepends = [ base Cabal filepath ];
  libraryHaskellDepends = [
    base binary bytestring containers ghc-heap template-haskell
    transformers
  ];
  testHaskellDepends = [ base deepseq ];
  description = "Extract the heap representation of Haskell values and thunks";
  license = stdenv.lib.licenses.bsd3;
}
