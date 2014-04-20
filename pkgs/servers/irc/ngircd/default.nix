{ stdenv, fetchurl, zlib, openssl, pam, libiconvOrNull }:

stdenv.mkDerivation rec {
  name = "ngircd-21";

  src = fetchurl {
    url = "http://ngircd.barton.de/pub/ngircd/${name}.tar.xz";
    sha256 = "19llx54zy6hc8k7kcs1f234qc20mqpnlnb30c663c42jxq5x6xii";
  };

  configureFlags = [
    "--with-syslog"
    "--with-zlib"
    "--with-pam"
    "--with-openssl"
    "--enable-ipv6"
    "--with-iconv"
  ];

  buildInputs = [ zlib pam openssl libiconvOrNull ];

  meta = {
    description = "Next Generation IRC Daemon";
    homepage    = http://ngircd.barton.de;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms   = stdenv.lib.platforms.all;
  };
}
