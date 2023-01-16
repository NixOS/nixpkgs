{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, SDL2
, aubio
, boost
, cmake
, ffmpeg
, gettext
, git
, glew
, glibmm
, glm
, icu
, libepoxy
, librsvg
, libxmlxx
, pango
, pkg-config
, portaudio
}:

let
  ced = fetchFromGitHub {
    owner = "performous";
    repo = "compact_enc_det";
    rev = "9ca1351fe0b1e85992a407b0fc54a63e9b3adc6e";
    hash = "sha256-ztfeblR4YnB5+lb+rwOQJjogl+C9vtPH9IVnYO7oxec=";
  };
in
stdenv.mkDerivation rec {
  pname = "performous";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/performous/performous/archive/refs/tags/${version}.tar.gz";
    hash = "sha256-yIQ4uzuUAKIlSpkoQ3UVdTSuOL78SLonJUvDuefvUO8=";
  };

  postPatch = ''
    mkdir ced-src
    cp -R ${ced}/* ced-src
    sed -z -i "s/include(FetchContent.*ced-sources)/add_subdirectory(ced-src)/" CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
  ];

  buildInputs = [
    SDL2
    aubio
    boost
    ffmpeg
    glew
    glibmm
    glm
    icu
    libepoxy
    librsvg
    libxmlxx
    pango
    portaudio
  ];

  meta = with lib; {
    homepage = "http://performous.org/";
    description = "Karaoke, band and dancing game";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
