{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "ccrypt-1.7";

  src = fetchurl {
    url = mirror://sourceforge/ccrypt/ccrypt-1.7.tar.gz;
    sha256 = "1bf974c9ee5f20332f0117c5b80784825f505f1a24eb57a10c8195c3ad16540e";
  };
  meta = {
    description = "Utility for encrypting and decrypting files and streams with AES-256";
    license = "GPLv2+";
  };
}
