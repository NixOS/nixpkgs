{ lib
, stdenv
, fetchurl
, openssl
, zlib
}:

stdenv.mkDerivation rec {
  pname = "siege";
  version = "4.0.8";

  src = fetchurl {
    url = "http://download.joedog.org/siege/${pname}-${version}.tar.gz";
    sha256 = "01qhw52kyqwidp5bckw4xmz4ldqdwkjci7k421qm68kk0mx9l48g";
  };

  NIX_LDFLAGS = lib.optionalString stdenv.isLinux "-lgcc_s";

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
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
