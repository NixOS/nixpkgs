{ mkDerivation, aeson, base, base16-bytestring, bytestring, conduit
, cookie, cryptonite, deepseq, exceptions, hspec, hspec-discover
, http-api-data, http-media, jose, lens, memory, nix-narinfo
, protolude, resourcet, servant, servant-auth, servant-auth-swagger
, servant-client, servant-swagger, servant-swagger-ui-core, stdenv
, string-conv, swagger2, text, time, transformers
}:
mkDerivation {
  pname = "cachix-api";
  version = "0.6.0";
  sha256 = "a3318984fe0a9c2b79f96bd0ad06cb103e5ae3460d48ec85a98115b068a1d360";
  libraryHaskellDepends = [
    aeson base base16-bytestring bytestring conduit cookie cryptonite
    deepseq exceptions http-api-data http-media jose lens memory
    nix-narinfo protolude resourcet servant servant-auth
    servant-auth-swagger servant-client string-conv swagger2 text time
    transformers
  ];
  testHaskellDepends = [
    aeson base base16-bytestring bytestring conduit cookie cryptonite
    hspec http-api-data http-media lens memory protolude servant
    servant-auth servant-auth-swagger servant-swagger
    servant-swagger-ui-core string-conv swagger2 text transformers
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/cachix/cachix#readme";
  description = "Servant HTTP API specification for https://cachix.org";
  license = stdenv.lib.licenses.asl20;
}
