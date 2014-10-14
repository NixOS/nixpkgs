{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name    = "stunnel-${version}";
  version = "5.05";

  src = fetchurl {
    url    = "http://www.stunnel.org/downloads/${name}.tar.gz";
    # SHA256 provided by upstream.
    sha256 = "c7e1653345150db7e48d00e1129cf571c7c85de8e7e1aa70b21cf1d76b1e31ef";
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
