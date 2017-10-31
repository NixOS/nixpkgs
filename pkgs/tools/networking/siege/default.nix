{ stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "siege-4.0.2";

  src = fetchurl {
    url = "http://download.joedog.org/siege/${name}.tar.gz";
    sha256 = "0ivc6ah9n2888qgh8dicszhr3mjs42538lfx7dlhxvvvakwq3yvy";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  buildInputs = [ openssl zlib ];

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-zlib=${zlib.dev}"
  ];

  meta = with stdenv.lib; {
    description = "HTTP load tester";
    maintainers = with maintainers; [ ocharles raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
