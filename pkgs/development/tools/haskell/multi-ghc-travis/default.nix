{ mkDerivation, ansi-terminal, base, bytestring, Cabal, containers
, deepseq, Diff, directory, filepath, ShellCheck, stdenv, tasty
, tasty-golden, transformers, fetchFromGitHub
}:
mkDerivation {
  pname = "haskell-ci";
  version = "0";
  src = fetchFromGitHub {
    owner = "haskell-CI";
    repo = "haskell-ci";
    rev = "db63eb7f2eaa64b7b0e4759e98258fea2a27a424";
    sha256 = "0ff55zafx7561s1yps7aw83ws4vcpc5cq9r6bbckaagvwwla0dcq";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base Cabal containers deepseq directory filepath ShellCheck
    transformers
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    ansi-terminal base bytestring Diff directory filepath tasty
    tasty-golden transformers
  ];
  homepage = "https://github.com/haskell-CI/haskell-ci";
  description = "Script generator for Travis-CI";
  license = stdenv.lib.licenses.bsd3;
}
