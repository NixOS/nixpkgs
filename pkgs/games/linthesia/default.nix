{ lib
, SDL2
, SDL2_image
, SDL2_ttf
, alsa-lib
, fetchFromGitHub
, glibmm
, gtk3
, libGL
, libGLU
, meson
, ninja
, pkg-config
, python3
, sqlite
, stdenv
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "linthesia";
  version = "unstable-2023-05-23";

  src = fetchFromGitHub {
    owner = "linthesia";
    repo = "linthesia";
    rev = "1f2701241f8865c2f5c14a97b81ae64884cf0396";
    sha256 = "sha256-3uPcpDUGtAGW9q/u8Cn+0bNqikII1Y/a0PKARW/5nao=";
  };

  postPatch = ''
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [ meson ninja pkg-config python3 wrapGAppsHook ];
  buildInputs = [
    libGL
    libGLU
    alsa-lib
    glibmm
    sqlite
    SDL2
    SDL2_ttf
    SDL2_image
    gtk3.out # icon cache
  ];

  meta = with lib; {
    description = "A game of playing music using a MIDI keyboard following a MIDI file";
    inherit (src.meta) homepage;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ckie ];
  };
}
