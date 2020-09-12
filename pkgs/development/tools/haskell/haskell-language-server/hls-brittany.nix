{ mkDerivation, aeson, base, butcher, bytestring, cmdargs
, containers, czipwith, data-tree-print, deepseq, directory, extra
, fetchgit, filepath, ghc, ghc-boot-th, ghc-exactprint, ghc-paths
, hspec, monad-memo, mtl, multistate, parsec, pretty, random, safe
, semigroups, stdenv, strict, syb, text, transformers, uniplate
, unsafe, yaml
}:
mkDerivation {
  pname = "brittany";
  version = "0.12.1.1";
  src = fetchgit {
    url = "https://github.com/bubba/brittany";
    sha256 = "1rkk09f8750qykrmkqfqbh44dbx1p8aq1caznxxlw8zqfvx39cxl";
    rev = "c59655f10d5ad295c2481537fc8abf0a297d9d1c";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base butcher bytestring cmdargs containers czipwith
    data-tree-print deepseq directory extra filepath ghc ghc-boot-th
    ghc-exactprint ghc-paths monad-memo mtl multistate pretty random
    safe semigroups strict syb text transformers uniplate unsafe yaml
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    aeson base butcher bytestring cmdargs containers czipwith
    data-tree-print deepseq directory extra filepath ghc ghc-boot-th
    ghc-exactprint ghc-paths hspec monad-memo mtl multistate parsec
    pretty safe semigroups strict syb text transformers uniplate unsafe
    yaml
  ];
  homepage = "https://github.com/lspitzner/brittany/";
  description = "Haskell source code formatter";
  license = stdenv.lib.licenses.agpl3;
}
