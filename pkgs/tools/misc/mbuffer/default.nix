{ lib
, stdenv
, fetchurl
, openssl
, which
}:

stdenv.mkDerivation rec {
  pname = "mbuffer";
  version = "20220418";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "sha256-blgB+fX/EURdHQMCi1oDzQivVAhpe3+UxCeDMiijAMc=";
  };

  buildInputs = [
    openssl
  ];
  nativeBuildInputs = [
    which
  ];

  doCheck = true;

  meta = with lib; {
    description  = "A tool for buffering data streams with a large set of unique features";
    homepage = "https://www.maier-komor.de/mbuffer.html";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tokudan ];
    platforms = platforms.linux; # Maybe other non-darwin Unix
  };
}
