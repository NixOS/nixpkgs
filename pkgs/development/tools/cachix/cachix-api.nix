{ mkDerivation, aeson, base, base16-bytestring, bytestring, conduit
, cookie, cryptonite, deepseq, exceptions, hspec, hspec-discover
, http-api-data, http-media, lens, memory, protolude, resourcet
, servant, servant-auth, servant-auth-server, servant-auth-swagger
, servant-client, servant-swagger, servant-swagger-ui-core, stdenv
, string-conv, swagger2, text, transformers
}:
mkDerivation {
  pname = "cachix-api";
  version = "0.2.0";
  sha256 = "73f27484d3748fe02ce834549dd3a04c92110390f7d9adb4c391bad2ececbef2";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base base16-bytestring bytestring conduit cookie cryptonite
    deepseq exceptions http-api-data http-media lens memory resourcet
    servant servant-auth servant-auth-server servant-auth-swagger
    servant-client servant-swagger string-conv swagger2 text
    transformers
  ];
  executableHaskellDepends = [ aeson base ];
  testHaskellDepends = [
    aeson base base16-bytestring bytestring conduit cookie cryptonite
    hspec http-api-data http-media lens memory protolude servant
    servant-auth servant-auth-server servant-auth-swagger
    servant-swagger servant-swagger-ui-core string-conv swagger2 text
    transformers
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/cachix/cachix#readme";
  description = "Servant HTTP API specification for https://cachix.org";
  license = stdenv.lib.licenses.asl20;
}
