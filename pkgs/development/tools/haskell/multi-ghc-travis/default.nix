{ mkDerivation, ansi-terminal, base, bytestring, Cabal, containers
, deepseq, Diff, directory, filepath, ShellCheck, stdenv, tasty
, tasty-golden, transformers, fetchFromGitHub, fetchpatch
}:

let

  newShellCheck = fetchpatch {
    url = https://github.com/haskell-CI/haskell-ci/pull/159.patch;
    sha256 = "17qn099lvfiii5z3hg24idmg4sk6ph7m2k940fsxzhqrad8fkjmw";
  };

in

mkDerivation {
  pname = "haskell-ci";
  version = "0";
  src = fetchFromGitHub {
    owner = "haskell-CI";
    repo = "haskell-ci";
    rev = "b592d290cff68c7abcbd7f99f41aac998e7b7916";
    sha256 = "0jwaifp9wx6lb27qj191hjm125kq3vndh5lf7ibd86x19h5zmy4c";
  };
  patches = [ newShellCheck ];
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
