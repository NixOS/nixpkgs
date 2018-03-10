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
    rev = "a4962f1478089654d138da7a3807dfcf2cef4284";
    sha256 = "1qwknajabxcfz5w5g0yn30r8p0180wxp7pncr6nwfhszlhay0vb7";
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
