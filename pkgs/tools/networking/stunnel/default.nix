{ stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  name    = "stunnel-${version}";
  version = "5.03";

  src = fetchurl {
    url    = "http://www.stunnel.org/downloads/${name}.tar.gz";
    sha256 = "00yx7r46rad3yhdqfwk4grqs87wc6fiq055i91pnwxgscsa3c7ls";
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
