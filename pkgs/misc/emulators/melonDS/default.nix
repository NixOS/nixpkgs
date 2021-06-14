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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "Arisotura";
    repo = pname;
    rev = version;
    sha256 = "sha256-bvi0Y+zwfEcsZMNxoH85hxwIGn0UIYlg/ZaE6yJ7vlo=";
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
