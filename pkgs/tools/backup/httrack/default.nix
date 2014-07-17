{ stdenv, fetchurl, zlib, openssl }:

stdenv.mkDerivation rec {
  version = "3.48.17";
  name = "httrack-${version}";

  src = fetchurl {
    url = "http://mirror.httrack.com/httrack-${version}.tar.gz";
    sha256 = "03q8sk7qihw9x4bfgfhv6523khgj13nilqps28qy7ndpzpggw9vn";
  };

  buildInputs = [ zlib openssl ];

  meta = {
    homepage = "http://www.httrack.com";
    description = "Easy-to-use offline browser utility";
    license = "GPL";
  };
}
