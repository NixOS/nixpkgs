{ lib
, stdenv
, fetchFromGitHub
, SDL2
, aubio
, boost
, cmake
, ffmpeg
, fmt
, gettext
, glew
, glibmm
, glm
, icu
, libepoxy
, librsvg
, libxmlxx
, nlohmann_json
, pango
, pkg-config
, portaudio
}:

stdenv.mkDerivation rec {
  pname = "performous";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "performous";
    repo = "performous";
    rev = "refs/tags/${version}";
    hash = "sha256-y7kxLht15vULN9NxM0wzj9+7Uq4/3D5j9oBEnrTIwQ8=";
  };

  cedSrc = fetchFromGitHub {
    owner = "performous";
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

    substituteInPlace data/CMakeLists.txt \
      --replace "/usr" "$out"
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
    fmt
    glew
    glibmm
    glm
    icu
    libepoxy
    librsvg
    libxmlxx
    nlohmann_json
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
