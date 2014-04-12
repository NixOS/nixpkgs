{ stdenv, fetchurl, zlib, openssl }:

stdenv.mkDerivation rec {
  version = "3.48.3";
  name = "httrack-${version}";

  src = fetchurl {
    url = "http://mirror.httrack.com/httrack-${version}.tar.gz";
    sha256 = "1lg5rrql01q3z7fwcij5p64r22x4vbswcky80gajx5f62kxlxn0r";
  };

  buildInputs = [ zlib openssl ];

  meta = {
    homepage = "http://www.httrack.com";
    description = "Easy-to-use offline browser utility";
    license = "GPL";
  };
}
