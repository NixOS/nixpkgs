{ mkDerivation, aeson, base, bytestring, Cabal, containers
, directory, exceptions, filelock, filepath, gitrev, graph-wrapper
, hpack, hspec, HUnit, language-dot, mockery, parsec, process
, QuickCheck, safe, stdenv, temporary, time, transformers, unix
, unix-compat, with-location, yaml, fetchFromGitHub
, cabal2nix, cabal-install, makeWrapper
}:
mkDerivation {
  pname = "tinc";
  version = "20170624";
  src = fetchFromGitHub {
    owner = "sol";
    repo = "tinc";
    rev = "70881515693fd83d381fe045ae76d5257774f5e3";
    sha256 = "0c6sx3vbcnq69dhqhpi01a4p4qss24rwxiz6jmw65rj73adhj4mw";
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
      --prefix PATH : '${cabal2nix}/bin' \
      --prefix PATH : '${cabal-install}/bin'
  '';
  description = "A dependency manager for Haskell";
  homepage = "https://github.com/sol/tinc#readme";
  license = stdenv.lib.licenses.mit;
  hydraPlatforms = [ "x86_64-linux" ];
  maintainers = [ stdenv.lib.maintainers.robbinch ];
}
