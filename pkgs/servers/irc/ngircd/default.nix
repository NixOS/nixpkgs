{ stdenv, fetchurl, zlib, openssl, pam, libiconv }:

stdenv.mkDerivation rec {
  name = "ngircd-24";

  src = fetchurl {
    url = "https://ngircd.barton.de/pub/ngircd/${name}.tar.xz";
    sha256 = "020h9d1awyxqr0l42x1fhs47q7cmm17fdxzjish8p2kq23ma0gqp";
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
    homepage    = http://ngircd.barton.de;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.all;
  };
}
