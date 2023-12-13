{ lib
, stdenv
, fetchurl
, openssl
, which
}:

stdenv.mkDerivation rec {
  pname = "mbuffer";
  version = "20230301";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "sha256-U/diCd7AD6soPcC8UyKw5jRrCdou27ZDWi1Kj0glLQE=";
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
    mainProgram = "mbuffer";
  };
}
