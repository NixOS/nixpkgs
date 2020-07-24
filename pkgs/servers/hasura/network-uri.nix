{ mkDerivation, base, deepseq, HUnit, parsec, stdenv
, test-framework, test-framework-hunit, test-framework-quickcheck2
}:
mkDerivation {
  pname = "network-uri";
  version = "2.6.1.0";
  sha256 = "423e0a2351236f3fcfd24e39cdbc38050ec2910f82245e69ca72a661f7fc47f0";
  revision = "1";
  editedCabalFile = "141nj7q0p9wkn5gr41ayc63cgaanr9m59yym47wpxqr3c334bk32";
  libraryHaskellDepends = [ base deepseq parsec ];
  testHaskellDepends = [
    base HUnit test-framework test-framework-hunit
    test-framework-quickcheck2
  ];
  homepage = "https://github.com/haskell/network-uri";
  description = "URI manipulation";
  license = stdenv.lib.licenses.bsd3;
}
