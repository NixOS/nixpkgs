{ lib
, fetchFromGitHub
, mkDerivation
, cmake
, libepoxy
, libarchive
, libpcap
, libslirp
, pkg-config
, qtbase
, SDL2
}:

mkDerivation rec {
  pname = "melonDS";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "Arisotura";
    repo = pname;
    rev = version;
    sha256 = "1v8a060gbpx7rdkk2w4hym361l2wip7yjjn8wny1gfsa273k3zy5";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    libepoxy
    libarchive
    libslirp
    qtbase
    SDL2
  ];

  qtWrapperArgs = [ "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libpcap ]}" ];

  meta = with lib; {
    homepage = "http://melonds.kuribo64.net/";
    description = "Work in progress Nintendo DS emulator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artemist benley shamilton xfix ];
    platforms = platforms.linux;
  };
}
