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
    rev = "05926968f17256cae2308756835a3a24d9de437b";
    sha256 = "0s1g1yq6j6vl2bspc90bwbwp7532pcrmh8fhnz8j6yv9py927mmm";
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
