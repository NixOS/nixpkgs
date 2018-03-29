{ mkDerivation, base, bytestring, Cabal, containers, deepseq, Diff
, directory, filepath, ShellCheck, stdenv, tasty, tasty-golden
, transformers, fetchFromGitHub
}:
mkDerivation {
  pname = "make-travis-yml";
  version = "0";
  src = fetchFromGitHub {
    owner = "haskell-CI";
    repo = "haskell-ci";
    rev = "7ca5d751c35c6dc43392397b4641c4611ed55121";
    sha256 = "04f9jcxqv1mn0rw31x23ns6xdhgqjv55blsksadwr25qn2521zxb";
  };
  jailbreak = true;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base Cabal containers deepseq directory filepath ShellCheck
    transformers
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base bytestring Diff directory filepath tasty tasty-golden
    transformers
  ];
  homepage = "https://github.com/haskell-CI/haskell-ci";
  description = "Script generator for Travis-CI";
  license = stdenv.lib.licenses.bsd3;
}
