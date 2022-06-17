{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "tinyalsa";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "tinyalsa";
    repo = "tinyalsa";
    rev = "v${version}";
    hash = "sha256-WFJbew6ApB9InKN1SyRkbVoFlBCFm5uYzazdtsaHM90=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DTINYALSA_USES_PLUGINS=ON"
  ];

  NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=stringop-truncation"
  ];

  meta = with lib; {
    homepage = "https://github.com/tinyalsa/tinyalsa";
    description = "Tiny library to interface with ALSA in the Linux kernel";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
