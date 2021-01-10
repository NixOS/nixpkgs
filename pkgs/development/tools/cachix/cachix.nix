{ mkDerivation, async, base, base64-bytestring, boost, bytestring
, cachix-api, concurrent-extra, conduit, conduit-extra, containers
, cookie, cryptonite, dhall, directory, ed25519, filepath, fsnotify
, here, hspec, hspec-discover, http-client, http-client-tls
, http-conduit, http-types, inline-c, inline-c-cpp, lzma-conduit
, megaparsec, memory, mmorph, netrc, nix, optparse-applicative
, process, protolude, resourcet, retry, safe-exceptions, servant
, servant-auth, servant-auth-client, servant-client
, servant-client-core, servant-conduit, stdenv, stm, temporary
, text, unix, uri-bytestring, vector, versions
}:
mkDerivation {
  pname = "cachix";
  version = "0.6.0";
  sha256 = "d49ad3f405b1ddcceda0f11319f78bcebf5c9a677fd84d087b9b5e7bad98c3ab";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    async base base64-bytestring bytestring cachix-api concurrent-extra
    conduit conduit-extra containers cookie cryptonite dhall directory
    ed25519 filepath fsnotify here http-client http-client-tls
    http-conduit http-types inline-c inline-c-cpp lzma-conduit
    megaparsec memory mmorph netrc optparse-applicative process
    protolude resourcet retry safe-exceptions servant servant-auth
    servant-auth-client servant-client servant-client-core
    servant-conduit stm text unix uri-bytestring vector versions
  ];
  patchPhase = ''
    substituteInPlace cachix.cabal --replace optcxx optc 
  '';
  librarySystemDepends = [ boost ];
  libraryPkgconfigDepends = [ nix ];
  executableHaskellDepends = [ base cachix-api ];
  executableToolDepends = [ hspec-discover ];
  testHaskellDepends = [
    base cachix-api directory here hspec protolude servant-auth-client
    temporary
  ];
  homepage = "https://github.com/cachix/cachix#readme";
  description = "Command line client for Nix binary cache hosting https://cachix.org";
  license = stdenv.lib.licenses.asl20;
}
