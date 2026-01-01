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

<<<<<<< HEAD
  meta = {
    description = "Secure ACME/Let's Encrypt client";
    homepage = "https://git.wolfsden.cz/acme-client-portable";
    platforms = lib.platforms.unix;
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ pmahoney ];
=======
  meta = with lib; {
    description = "Secure ACME/Let's Encrypt client";
    homepage = "https://git.wolfsden.cz/acme-client-portable";
    platforms = platforms.unix;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "acme-client";
  };
}
