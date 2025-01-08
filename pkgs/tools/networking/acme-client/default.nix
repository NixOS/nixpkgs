{
  lib,
  stdenv,
  fetchurl,
  libbsd,
  libressl,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "acme-client";
  version = "1.3.3";

  src = fetchurl {
    url = "https://data.wolfsden.cz/sources/acme-client-${version}.tar.gz";
    hash = "sha256-HJOk2vlDD7ADrLdf/eLEp+teu9XN0KrghEe6y4FIDoI=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libbsd
    libressl
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Secure ACME/Let's Encrypt client";
    homepage = "https://git.wolfsden.cz/acme-client-portable";
    platforms = platforms.unix;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
    mainProgram = "acme-client";
  };
}
