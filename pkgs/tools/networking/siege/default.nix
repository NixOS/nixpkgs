{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "siege";
  version = "4.1.6";

  src = fetchurl {
    url = "http://download.joedog.org/siege/${pname}-${version}.tar.gz";
    hash = "sha256-MJ1Ym/yBm28V0uXoWRs8DG9pNiT1Bg7qwGek2ad1fek=";
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
    changelog = "https://github.com/JoeDog/siege/blob/v${version}/ChangeLog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
