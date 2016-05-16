{ mkDerivation, aeson, base, bytestring, Cabal, containers
, directory, exceptions, filelock, filepath, gitrev, graph-wrapper
, hpack, hspec, HUnit, language-dot, mockery, parsec, process
, QuickCheck, safe, stdenv, temporary, time, transformers, unix
, unix-compat, with-location, yaml, fetchFromGitHub
, ghc, cabal2nix, cabal-install, makeWrapper
}:
mkDerivation {
  pname = "tinc";
  version = "20160511";
  src = fetchFromGitHub {
    owner = "sol";
    repo = "tinc";
    rev = "405af997c182b89edfc9656612c32616e98c7862";
    sha256 = "0zryw3abp64922dnk6jss58lq4k7ijwbbn35zh5vbg3ns8307k6b";
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
