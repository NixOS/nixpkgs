{ stdenv, fetchurl, pcre, libxml2, zlib, attr, bzip2 }:

stdenv.mkDerivation {
  name = "lighttpd-1.4.30";

  src = fetchurl {
    url = http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.30.tar.xz;
    sha256 = "c237692366935b19ef8a6a600b2f3c9b259a9c3107271594c081a45902bd9c9b";
  };

  buildInputs = [ pcre libxml2 zlib attr bzip2 ];

  meta = {
    description = "Lightweight high-performance web server";
    homepage = http://www.lighttpd.net/;
    license = "BSD";
  };
}
