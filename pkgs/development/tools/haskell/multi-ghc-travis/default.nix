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
    rev = "0d1b4089f6829659149747c9551712d24fd0b124";
    sha256 = "00dbg8hbncv74c2baskyhg4h0yv8wrz0fnkvw2bzcn0cjrz7xqwr";
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
