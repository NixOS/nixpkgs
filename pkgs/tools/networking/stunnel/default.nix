{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name    = "stunnel-${version}";
  version = "5.01";

  src = fetchurl {
    url    = "http://www.stunnel.org/downloads/${name}.tar.gz";
    sha256 = "0sw87x7yrgjx43a5x0cy71p2vr5j0l8n5pv49hq159p8zxcbyr95";
  };

  buildInputs = [ openssl ];
  configureFlags = [ "--with-ssl=${openssl}" ];

  meta = {
    description = "universal tls/ssl wrapper";
    homepage    = "http://www.stunnel.org/";
    license     = stdenv.lib.licenses.gpl2Plus;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
