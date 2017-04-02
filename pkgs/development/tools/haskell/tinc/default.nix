{ mkDerivation, aeson, base, bytestring, Cabal, containers
, directory, exceptions, filelock, filepath, gitrev, graph-wrapper
, hpack, hspec, HUnit, language-dot, mockery, parsec, process
, QuickCheck, safe, stdenv, temporary, time, transformers, unix
, unix-compat, with-location, yaml, fetchFromGitHub
, ghc, cabal2nix, cabal-install, makeWrapper
}:
mkDerivation {
  pname = "tinc";
  version = "20170228";
  src = fetchFromGitHub {
    owner = "sol";
    repo = "tinc";
    rev = "e829926a043a68a8a4dc551485c4d666837474af";
    sha256 = "1zdp1mqp3jn2faw0d3jlcbrkp4azgl5ahhq5pxdn24gyq70zkchc";
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
  hydraPlatforms = stdenv.lib.platforms.none;
  maintainers = [ stdenv.lib.maintainers.robbinch ];
}
