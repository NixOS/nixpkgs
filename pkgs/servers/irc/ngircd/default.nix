{ stdenv, fetchurl, zlib, openssl, pam, libiconv }:

stdenv.mkDerivation rec {
  pname = "ngircd";
  version = "26";

  src = fetchurl {
    url = "https://ngircd.barton.de/pub/ngircd/${pname}-${version}.tar.xz";
    sha256 = "1ijmv18fa648y7apxb9vp4j9iq6fxq850kz5v36rysaq614cdp2n";
  };

  configureFlags = [
    "--with-syslog"
    "--with-zlib"
    "--with-pam"
    "--with-openssl"
    "--enable-ipv6"
    "--with-iconv"
  ];

  buildInputs = [ zlib pam openssl libiconv ];

  meta = {
    description = "Next Generation IRC Daemon";
    homepage    = "https://ngircd.barton.de";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.all;
  };
}
