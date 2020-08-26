{ stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "siege-4.0.6";

  src = fetchurl {
    url = "http://download.joedog.org/siege/${name}.tar.gz";
    sha256 = "03w0iska74nb6r8wnljn7inasbq7qflf55vjmxnb9jrc4pi7mpnw";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  buildInputs = [ openssl zlib ];

  prePatch = ''
    sed -i -e 's/u_int32_t/uint32_t/g' -e '1i#include <stdint.h>' src/hash.c
  '';

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-zlib=${zlib.dev}"
  ];

  meta = with stdenv.lib; {
    description = "HTTP load tester";
    maintainers = with maintainers; [ ocharles raskin ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
