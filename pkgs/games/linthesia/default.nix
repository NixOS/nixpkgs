{ lib
, SDL2
, SDL2_image
, SDL2_ttf
, alsa-lib
, fetchFromGitHub
, fetchpatch2
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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "linthesia";
    repo = "linthesia";
    rev = version;
    sha256 = "sha256-bdW0RlV14ttnK8NizfNfXmZ7zlJOqZCpVvt8vT2Pjys=";
  };

  patches = [
    # fix: text looks garbled with SDL2_ttf 2.0.18
    (fetchpatch2 {
      url = "https://github.com/linthesia/linthesia/commit/bd647270b3bdf79a9af6ac1e2203c9e860d16c58.patch";
      hash = "sha256-hNal0eVfikRSpW+MOfpKvnWXrEJgIXHPAtNPB9SvHVU=";
    })
  ];

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
  };
}
