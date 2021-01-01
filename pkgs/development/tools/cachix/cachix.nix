{ mkDerivation, async, base, base64-bytestring, boost, bytestring
 , cachix-api, conduit, conduit-extra, containers, cookie
 , cryptonite, dhall, directory, ed25519, filepath, fsnotify, here
 , hspec, hspec-discover, http-client, http-client-tls, http-conduit
 , http-types, inline-c, inline-c-cpp, lzma-conduit, megaparsec
 , memory, mmorph, netrc, nix, optparse-applicative, process
 , protolude, resourcet, retry, safe-exceptions, servant
 , servant-auth, servant-auth-client, servant-client
 , servant-client-core, servant-conduit, temporary, text, unix
 , uri-bytestring, vector, versions, stdenv
 }:
 mkDerivation {
   pname = "cachix";
   version = "0.5.1";
   sha256 = "13xl87jgpa1swgppr86dylp8ndisasdr8zcmk1l2jjb7vgyly8mb";
   isLibrary = true;
   isExecutable = true;
   libraryHaskellDepends = [
     async base base64-bytestring bytestring cachix-api conduit
     conduit-extra containers cookie cryptonite dhall directory ed25519
     filepath fsnotify here http-client http-client-tls http-conduit
     http-types inline-c inline-c-cpp lzma-conduit megaparsec memory
     mmorph netrc optparse-applicative process protolude resourcet retry
     safe-exceptions servant servant-auth servant-auth-client
     servant-client servant-client-core servant-conduit text unix
     uri-bytestring vector versions
   ];
   librarySystemDepends = [ boost ];
   libraryPkgconfigDepends = [ nix ];
   executableHaskellDepends = [ base cachix-api ];
   executableToolDepends = [ hspec-discover ];
   testHaskellDepends = [
     base cachix-api directory here hspec protolude servant-auth-client
     temporary
   ];
   description = "Command line client for Nix binary cache hosting https://cachix.org";
   license = stdenv.lib.licenses.asl20;
 }