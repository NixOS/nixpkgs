{ mkDerivation, async, base, base16-bytestring, base64-bytestring
, bytestring, cachix-api, conduit, conduit-extra, cookie
, cryptonite, data-default, dhall, directory, ed25519, filepath
, fsnotify, here, hspec, hspec-discover, http-client
, http-client-tls, http-conduit, http-types, lzma-conduit
, megaparsec, memory, mmorph, netrc, optparse-applicative, process
, protolude, retry, safe-exceptions, servant, servant-auth
, servant-auth-client, servant-client, servant-client-core
, servant-conduit, stdenv, temporary, text, unix, uri-bytestring
, versions
}:
mkDerivation {
  pname = "cachix";
  version = "0.2.0";
  sha256 = "16ba70af7f2ba4bc147ba84c34c9884bee589237a1d935f932c5e0b68157665a";
  revision = "1";
  editedCabalFile = "103ypqp0kclc1814q2ci5fi2jpfbxwmjqfsnkvwf3c1vr8cqplmh";
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    async base base16-bytestring base64-bytestring bytestring
    cachix-api conduit conduit-extra cookie cryptonite data-default
    dhall directory ed25519 filepath fsnotify here http-client
    http-client-tls http-conduit http-types lzma-conduit megaparsec
    memory mmorph netrc optparse-applicative process protolude retry
    safe-exceptions servant servant-auth servant-auth-client
    servant-client servant-client-core servant-conduit text unix
    uri-bytestring versions
  ];
  executableHaskellDepends = [ base cachix-api ];
  executableToolDepends = [ hspec-discover ];
  testHaskellDepends = [
    base cachix-api directory here hspec protolude temporary
  ];
  homepage = "https://github.com/cachix/cachix#readme";
  description = "Command line client for Nix binary cache hosting https://cachix.org";
  license = stdenv.lib.licenses.asl20;
}
