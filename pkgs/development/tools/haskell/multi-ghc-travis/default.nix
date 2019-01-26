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
    rev = "18a7f5edcde360cea0740ff143eff1113ecda7d2";
    sha256 = "00gxpxb5n1a1v562fd4cg1j92vwmd2zp00c2j60piyl8ppxxa115";
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
