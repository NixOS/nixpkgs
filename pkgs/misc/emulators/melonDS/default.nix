{ lib
, fetchFromGitHub
, mkDerivation
, cmake
, pkg-config
, SDL2
, qtbase
, libpcap
, libslirp
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "melonDS";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "Arisotura";
    repo = pname;
    rev = version;
    sha256 = "0m45m1ch0az8l3d3grjbqvi5vvydbffxwka9w3k3qiia50m7fnph";
  };

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook ];
  buildInputs = [
    SDL2
    qtbase
    libpcap
    libslirp
  ];

  cmakeFlags = [ "-UUNIX_PORTABLE" ];

  meta = with lib; {
    homepage = "http://melonds.kuribo64.net/";
    description = "Work in progress Nintendo DS emulator";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artemist benley shamilton ];
    platforms = platforms.linux;
  };
}
