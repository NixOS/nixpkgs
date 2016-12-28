{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name    = "stunnel-${version}";
  version = "5.39b8";

  src = fetchurl {
    url    = "http://www.stunnel.org/downloads/beta/${name}.tar.gz";
    sha256 = "16zg5d8851fv8hgphvxfl5gmh11x2qb563y64p0c4ami2j76ynkv";
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
