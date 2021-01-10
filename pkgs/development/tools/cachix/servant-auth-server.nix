{ mkDerivation, aeson, base, base64-bytestring, blaze-builder
, bytestring, case-insensitive, cookie, data-default-class, entropy
, hspec, hspec-discover, http-client, http-types, jose, lens
, lens-aeson, markdown-unlit, memory, monad-time, mtl, QuickCheck
, servant, servant-auth, servant-server, stdenv, tagged, text, time
, transformers, unordered-containers, wai, warp, wreq
}:
mkDerivation {
  pname = "servant-auth-server";
  version = "0.4.6.0";
  sha256 = "73de660d9babb2610fd6a928d702397081ebdeda22e301df457a39f8ff4d5447";
  libraryHaskellDepends = [
    aeson base base64-bytestring blaze-builder bytestring
    case-insensitive cookie data-default-class entropy http-types jose
    lens memory monad-time mtl servant servant-auth servant-server
    tagged text time unordered-containers wai
  ];
  testHaskellDepends = [
    aeson base bytestring case-insensitive hspec http-client http-types
    jose lens lens-aeson mtl QuickCheck servant servant-auth
    servant-server time transformers wai warp wreq
  ];
  testToolDepends = [ hspec-discover markdown-unlit ];
  homepage = "http://github.com/haskell-servant/servant-auth#readme";
  description = "servant-server/servant-auth compatibility";
  license = stdenv.lib.licenses.bsd3;
}
