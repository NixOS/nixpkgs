{ mkDerivation, aeson, base, bytestring, Cabal, containers
, directory, exceptions, filelock, filepath, gitrev, graph-wrapper
, hpack, hspec, HUnit, language-dot, mockery, parsec, process
, QuickCheck, safe, stdenv, temporary, time, transformers, unix
, unix-compat, with-location, yaml, fetchFromGitHub
, ghc, cabal2nix, cabal-install, makeWrapper
}:
mkDerivation {
  pname = "tinc";
  version = "20161119";
  src = fetchFromGitHub {
    owner = "sol";
    repo = "tinc";
    rev = "8e31ed920ad1660b3bc458b4f6b281bacaf4bd14";
    sha256 = "0y9pvr20p9z4dddbfxgy9hl3ny7pxixxjg8ij7g8l14br6mcak30";
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
