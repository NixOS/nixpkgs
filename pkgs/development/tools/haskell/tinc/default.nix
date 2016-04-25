{ mkDerivation, aeson, base, bytestring, Cabal, containers
, directory, exceptions, filelock, filepath, gitrev, graph-wrapper
, hpack, hspec, HUnit, language-dot, mockery, parsec, process
, QuickCheck, safe, stdenv, temporary, time, transformers, unix
, unix-compat, with-location, yaml, fetchFromGitHub
, ghc, cabal2nix, cabal-install, makeWrapper
}:
mkDerivation {
  pname = "tinc";
  version = "20160419";
  src = fetchFromGitHub {
    owner = "sol";
    repo = "tinc";
    rev = "b9f7cc1076098b1f99f20655052c9fd34598d891";
    sha256 = "1f0k7a4vxdd2cd2h5qwska9hfw7ig6q2rx87d09fg2xlix96g81r";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base bytestring Cabal containers directory exceptions
    filelock filepath gitrev graph-wrapper hpack language-dot parsec
    process temporary time transformers unix-compat with-location yaml
  ];
  testHaskellDepends = [
    aeson base bytestring Cabal containers directory exceptions
    filelock filepath gitrev graph-wrapper hpack hspec HUnit
    language-dot mockery parsec process QuickCheck safe temporary time
    transformers unix unix-compat with-location yaml
  ];
  postInstall = ''
    source ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/tinc \
      --prefix PATH : '${ghc}/bin' \
      --prefix PATH : '${cabal2nix}/bin' \
      --prefix PATH : '${cabal-install}/bin'
  '';
  description = "A dependency manager for Haskell";
  homepage = "https://github.com/sol/tinc#readme";
  license = stdenv.lib.licenses.mit;
  maintainers = [ stdenv.lib.maintainers.robbinch ];
}
