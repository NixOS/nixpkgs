<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, python3, libGL, libGLU
, alsa-lib, glibmm, sqlite, SDL2, SDL2_ttf_2_0_15, SDL2_image, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "linthesia";
  version = "0.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linthesia";
    repo = "linthesia";
<<<<<<< HEAD
    rev = "1f2701241f8865c2f5c14a97b81ae64884cf0396";
    sha256 = "sha256-3uPcpDUGtAGW9q/u8Cn+0bNqikII1Y/a0PKARW/5nao=";
=======
    rev = version;
    sha256 = "sha256-bdW0RlV14ttnK8NizfNfXmZ7zlJOqZCpVvt8vT2Pjys=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    SDL2_ttf
=======
    SDL2_ttf_2_0_15
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    SDL2_image
    gtk3.out # icon cache
  ];

  meta = with lib; {
    description = "A game of playing music using a MIDI keyboard following a MIDI file";
    inherit (src.meta) homepage;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
<<<<<<< HEAD
    maintainers = with maintainers; [ ckie ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
