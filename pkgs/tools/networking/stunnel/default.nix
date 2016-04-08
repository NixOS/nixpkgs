{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name    = "stunnel-${version}";
  version = "5.31";

  src = fetchurl {
    url    = "http://www.stunnel.org/downloads/${name}.tar.gz";
    sha256 = "1dz0p85ha78vxc2hjhrkr4xf8w3q8r177bqdrgm26v6wncdbfim7";
  };

  buildInputs = [ openssl ];
  configureFlags = [
    "--with-ssl=${openssl}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    description = "universal tls/ssl wrapper";
    homepage    = "http://www.stunnel.org/";
    license     = stdenv.lib.licenses.gpl2Plus;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
