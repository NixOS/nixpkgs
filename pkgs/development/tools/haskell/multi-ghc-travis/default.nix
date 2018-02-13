{ mkDerivation, base, bytestring, Cabal, containers, deepseq, Diff
, directory, filepath, ShellCheck, stdenv, tasty, tasty-golden
, transformers, fetchFromGitHub
}:
mkDerivation {
  pname = "make-travis-yml";
  version = "0";
  src = fetchFromGitHub {
    owner = "hvr";
    repo = "multi-ghc-travis";
    rev = "612a29439ba61b01efb98ea6d36b7ffd987dc5a0";
    sha256 = "0q416rzzwipbnvslhwmm43w38dwma3lks12fghb0svcwj5lzgxsf";
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
  homepage = "https://github.com/hvr/multi-ghc-travis";
  description = "Script generator for Travis-CI";
  license = stdenv.lib.licenses.bsd3;
}
