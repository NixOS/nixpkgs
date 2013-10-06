{ stdenv, fetchurl, zlib, openssl }:

stdenv.mkDerivation rec {
  version = "3.47.21";
  name = "httrack-${version}";

  src = fetchurl {
    url = "http://mirror.httrack.com/httrack-${version}.tar.gz";
    sha256 = "1jqw0zx74jpi0svivvqhja3ixcrfkh9sbi9fwfw83jga27bc1sp0";
  };

  buildInputs = [ zlib openssl ];

  meta = {
    homepage = "http://www.httrack.com";
    description = "Easy-to-use offline browser utility";
    license = "GPL";
  };
}
