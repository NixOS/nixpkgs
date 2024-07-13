{ lib
, stdenv
, fetchurl
, openssl
, which
}:

stdenv.mkDerivation rec {
  pname = "mbuffer";
  version = "20240107";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "sha256-14YG4X3ZAmpTI21ezAenAgLSZC0X49kHRxzbWKBFiBQ=";
  };

  buildInputs = [
    openssl
  ];
  nativeBuildInputs = [
    which
  ];

  doCheck = true;

  meta = with lib; {
    description  = "Tool for buffering data streams with a large set of unique features";
    homepage = "https://www.maier-komor.de/mbuffer.html";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux; # Maybe other non-darwin Unix
    mainProgram = "mbuffer";
  };
}
