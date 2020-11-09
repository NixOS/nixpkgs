    { mkDerivation, aeson, base, base16-bytestring, bytestring
     , conduit, cookie, cryptonite, deepseq, exceptions, hspec
     , hspec-discover, http-api-data, http-media, jose, lens, memory
     , nix-narinfo, protolude, resourcet, servant, servant-auth
     , servant-auth-server, servant-auth-swagger, servant-client
     , servant-swagger, servant-swagger-ui-core, string-conv, swagger2
     , text, time, transformers, stdenv
     }:
     mkDerivation {
       pname = "cachix-api";
       version = "0.5.0";
       sha256 = "14b4vg6wv7kzxkfbh64ml2wvm9w8fyv2k2sm7ncaa0pp0f26pswy";
       libraryHaskellDepends = [
         aeson base base16-bytestring bytestring conduit cookie cryptonite
         deepseq exceptions http-api-data http-media jose lens memory
         nix-narinfo protolude resourcet servant servant-auth
         servant-auth-server servant-client string-conv swagger2 text time
         transformers
       ];
       testHaskellDepends = [
         aeson base base16-bytestring bytestring conduit cookie cryptonite
         hspec http-api-data http-media lens memory protolude servant
         servant-auth servant-auth-server servant-auth-swagger
         servant-swagger servant-swagger-ui-core string-conv swagger2 text
         transformers
       ];
       testToolDepends = [ hspec-discover ];
       description = "Servant HTTP API specification for https://cachix.org";
       license = stdenv.lib.licenses.asl20;
     }
