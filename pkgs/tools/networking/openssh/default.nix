{stdenv, fetchurl, zlib, openssl}:
 
stdenv.mkDerivation {
  name = "openssh-3.8.1p1";
 
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.bit.nl/mirror/openssh/openssh-3.8.1p1.tar.gz;
    md5 = "1dbfd40ae683f822ae917eebf171ca42";
  };
 
  buildInputs = [zlib openssl];
}
