{ mkDerivation, base, hspec, hspec-discover, lens, QuickCheck
, servant, servant-auth, servant-swagger, stdenv, swagger2, text
}:
mkDerivation {
  pname = "servant-auth-swagger";
  version = "0.2.10.1";
  sha256 = "bea98514817ad718a9402658deb5de36ff7856c0ec2d23a04289f2cec9da3609";
  libraryHaskellDepends = [
    base lens servant servant-auth servant-swagger swagger2 text
  ];
  testHaskellDepends = [
    base hspec lens QuickCheck servant servant-auth servant-swagger
    swagger2 text
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "http://github.com/haskell-servant/servant-auth#readme";
  description = "servant-swagger/servant-auth compatibility";
  license = stdenv.lib.licenses.bsd3;
}
