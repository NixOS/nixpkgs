{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name    = "stunnel-${version}";
  version = "5.38";

  src = fetchurl {
    url    = "http://www.stunnel.org/downloads/${name}.tar.gz";
    sha256 = "1mag0gd52f5q1jj3ds1pcn3s09si63cbxmri3zyv2fk8l6ds5b89";
  };

  buildInputs = [ openssl ];
  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    description = "Universal tls/ssl wrapper";
    homepage    = "http://www.stunnel.org/";
    license     = stdenv.lib.licenses.gpl2Plus;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
