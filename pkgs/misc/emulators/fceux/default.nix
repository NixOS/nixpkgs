{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, wrapQtAppsHook, SDL2, lua5_1, minizip, x264 }:

stdenv.mkDerivation rec {
  pname = "fceux";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "TASVideos";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-i0mb0vy46D97oOpAjMw3CPbG4w/LWP9YRVEMWjdYgs0=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];
  buildInputs = [ SDL2 lua5_1 minizip x264 ];

  meta = with lib; {
    description = "A Nintendo Entertainment System (NES) Emulator";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sbruder scubed2 ];
    homepage = "http://www.fceux.com/";
    platforms = platforms.linux;
  };
}
