{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, python3, libGL, libGLU
, alsa-lib, glibmm, sqlite, SDL2, SDL2_ttf_2_0_15, SDL2_image, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "linthesia";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "linthesia";
    repo = "linthesia";
    rev = version;
    sha256 = "sha256-bdW0RlV14ttnK8NizfNfXmZ7zlJOqZCpVvt8vT2Pjys=";
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
    SDL2_ttf_2_0_15
    SDL2_image
    gtk3.out # icon cache
  ];

  meta = with lib; {
    description = "A game of playing music using a MIDI keyboard following a MIDI file";
    inherit (src.meta) homepage;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
