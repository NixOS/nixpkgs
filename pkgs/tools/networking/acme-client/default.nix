{ lib
, stdenv
, fetchurl
, libbsd
, libressl
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "acme-client";
<<<<<<< HEAD
  version = "1.3.2";

  src = fetchurl {
    url = "https://data.wolfsden.cz/sources/acme-client-${version}.tar.gz";
    hash = "sha256-nVB0VIT6mwKwSTY+wDcuxMtpEjtZ9Z0ke0lJ7SzdsJ0=";
=======
  version = "1.3.1";

  src = fetchurl {
    url = "https://data.wolfsden.cz/sources/acme-client-${version}.tar.gz";
    hash = "sha256-lMCDis4CZQF6YwZGzdWD92/S1yT2cEAXXlTAipYYxro=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

