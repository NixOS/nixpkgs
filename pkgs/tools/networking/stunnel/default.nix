{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name    = "stunnel-${version}";
  version = "5.36";

  src = fetchurl {
    url    = "http://www.stunnel.org/downloads/${name}.tar.gz";
    sha256 = "1smmwkzr0i6w4jwrjxazbyf82jq1qlg8x9zil5b51pzwzpy552gb";
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
