{ mkDerivation, ansi-terminal, base, bytestring, Cabal, containers
, deepseq, Diff, directory, filepath, ShellCheck, stdenv, tasty
, tasty-golden, transformers, fetchFromGitHub
}:

mkDerivation rec {
  pname = "haskell-ci";
  version = "v0.1.0.0";
  src = fetchFromGitHub {
    owner = "haskell-CI";
    repo = "haskell-ci";
    rev = version;
    sha256 = "1r79dbgjq97h30xa3xhf75l0bivag8an9ag00mgzgpglvgc96czm";
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
