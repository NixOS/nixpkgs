{ stdenv, fetchurl, pcre, libxml2, zlib, attr, bzip2, which, file }:

stdenv.mkDerivation {
  name = "lighttpd-1.4.32";

  src = fetchurl {
    url = http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.32.tar.xz;
    sha256 = "1hgd9bi4mrak732h57na89lqg58b1kkchnddij9gawffd40ghs0k";
  };

  buildInputs = [ pcre libxml2 zlib attr bzip2 which file ];

  preConfigure = ''
    sed -i "s:/usr/bin/file:${file}/bin/file:g" configure
  '';

  meta = {
    description = "Lightweight high-performance web server";
    homepage = http://www.lighttpd.net/;
    license = "BSD";
  };
}
