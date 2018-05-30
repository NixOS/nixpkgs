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
    rev = "a0d76bc5dde3b1cc790a32f84b9ce084e7596f1e";
    sha256 = "1wrn9f5rz0nafcwisima6rp18v3a2kjgsyq2wj7vhinqwx9z72r4";
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
