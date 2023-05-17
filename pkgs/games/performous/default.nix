{ lib
, stdenv
, fetchFromGitHub
, SDL2
, aubio
, boost
, cmake
, ffmpeg_4
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

stdenv.mkDerivation rec {
  pname = "performous";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ueTSirov/lj4/IzaMqHitbOqx8qqUpsTghcb9DUnNEg=";
  };

  cedSrc = fetchFromGitHub {
    owner = pname;
    repo = "compact_enc_det";
    rev = "9ca1351fe0b1e85992a407b0fc54a63e9b3adc6e";
    hash = "sha256-ztfeblR4YnB5+lb+rwOQJjogl+C9vtPH9IVnYO7oxec=";
  };

  patches = [
    ./performous-cmake.patch
    ./performous-fftw.patch
  ];

  postPatch = ''
    mkdir ced-src
    cp -R ${cedSrc}/* ced-src
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
    ffmpeg_4
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
    description = "Karaoke, band and dancing game";
    homepage = "https://performous.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.linux;
  };
}
