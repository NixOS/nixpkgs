{ lib
, stdenv
, fetchurl
, libbsd
, libressl
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "acme-client";
  version = "1.3.1";

  src = fetchurl {
    url = "https://data.wolfsden.cz/sources/acme-client-${version}.tar.gz";
    hash = "sha256-lMCDis4CZQF6YwZGzdWD92/S1yT2cEAXXlTAipYYxro=";
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
    homepage = "https://sr.ht/~graywolf/acme-client-portable/";
    platforms = platforms.unix;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
  };
}

