{ lib
, stdenv
, fetchurl
, openssl
, zlib
}:

stdenv.mkDerivation rec {
  pname = "siege";
  version = "4.1.4";

  src = fetchurl {
    url = "http://download.joedog.org/siege/${pname}-${version}.tar.gz";
    hash = "sha256-zkPfnH9rCBqE52CxaEMlGUebrrRXtHTAl6/6W0UqRcs=";
  };

  NIX_LDFLAGS = lib.optionalString stdenv.isLinux [
    "-lgcc_s"
  ];

  buildInputs = [
    openssl
    zlib
  ];

  prePatch = ''
    sed -i -e 's/u_int32_t/uint32_t/g' -e '1i#include <stdint.h>' src/hash.c
  '';

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-zlib=${zlib.dev}"
  ];

  meta = with lib; {
    description = "HTTP load tester";
    homepage = "https://www.joedog.org/siege-home/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
