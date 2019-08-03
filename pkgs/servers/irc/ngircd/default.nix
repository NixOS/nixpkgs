{ stdenv, fetchurl, zlib, openssl, pam, libiconv }:

stdenv.mkDerivation rec {
  name = "ngircd-25";

  src = fetchurl {
    url = "https://ngircd.barton.de/pub/ngircd/${name}.tar.xz";
    sha256 = "0kpf5qi98m9f833r4rx9n6h9p31biwk798jwc1mgzmix7sp7r6f4";
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
    homepage    = https://ngircd.barton.de;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.all;
  };
}
