{ stdenv, fetchurl, pcre, libxml2, zlib, attr, bzip2 }:

stdenv.mkDerivation {
  name = "lighttpd-1.4.19";

  src = fetchurl {
    url = http://www.lighttpd.net/download/lighttpd-1.4.19.tar.bz2;
    sha256 = "1mziqb36ik9z4lf1h5ccm1h4ab7d2hx0cz0g5425lwy374r34fd2";
  };

  buildInputs = [ pcre libxml2 zlib attr bzip2 ];

  meta = {
    description = "Lightweight high-performance web server";
    homepage = http://www.lighttpd.net/;
    license = "BSD";
  };
}
