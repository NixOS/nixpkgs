{ lib, stdenv, fetchurl, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "siege-4.0.7";

  src = fetchurl {
    url = "http://download.joedog.org/siege/${name}.tar.gz";
    sha256 = "1y3dnl1ziw0c0d4nw30aj0sdmjvarn4xfxgfkswffwnkm8z5p9xz";
  };

  NIX_LDFLAGS = lib.optionalString stdenv.isLinux "-lgcc_s";

  buildInputs = [ openssl zlib ];

  prePatch = ''
    sed -i -e 's/u_int32_t/uint32_t/g' -e '1i#include <stdint.h>' src/hash.c
  '';

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-zlib=${zlib.dev}"
  ];

  meta = with lib; {
    description = "HTTP load tester";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
