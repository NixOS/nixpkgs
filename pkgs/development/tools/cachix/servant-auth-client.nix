{ mkDerivation, aeson, base, bytestring, containers, hspec
, hspec-discover, http-client, http-types, jose, QuickCheck
, servant, servant-auth, servant-auth-server, servant-client
, servant-client-core, servant-server, stdenv, time, transformers
, wai, warp
}:
mkDerivation {
  pname = "servant-auth-client";
  version = "0.4.1.0";
  sha256 = "03c1c9e1413c05ae30c269a2fef07e68bf41ff675edd180452d863d073e3359b";
  revision = "1";
  editedCabalFile = "0q7bazq4ilijclpz23fshpjcspnrfalh7jhqi5gg03m00wwibn4n";
  libraryHaskellDepends = [
    base bytestring containers servant servant-auth servant-client-core
  ];
  testHaskellDepends = [
    aeson base bytestring hspec http-client http-types jose QuickCheck
    servant servant-auth servant-auth-server servant-client
    servant-server time transformers wai warp
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "http://github.com/haskell-servant/servant-auth#readme";
  description = "servant-client/servant-auth compatibility";
  license = stdenv.lib.licenses.bsd3;
}
