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
    rev = "36b2ee58b9fd160d606608832625b2b6c32aec43";
    sha256 = "16g99jh5bszvfvb7mmyhl95mkf1l3ydyax8d9py91hi3m8r0c2x0";
  };
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
