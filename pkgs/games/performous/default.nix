{ lib
, stdenv
, fetchFromGitHub
, SDL2
, aubio
, boost
, cmake
<<<<<<< HEAD
, ffmpeg
, fmt
, gettext
=======
, ffmpeg_4
, gettext
, git
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, glew
, glibmm
, glm
, icu
, libepoxy
, librsvg
, libxmlxx
<<<<<<< HEAD
, nlohmann_json
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pango
, pkg-config
, portaudio
}:

stdenv.mkDerivation rec {
  pname = "performous";
<<<<<<< HEAD
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "performous";
    repo = "performous";
    rev = "refs/tags/${version}";
    hash = "sha256-y7kxLht15vULN9NxM0wzj9+7Uq4/3D5j9oBEnrTIwQ8=";
  };

  cedSrc = fetchFromGitHub {
    owner = "performous";
=======
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ueTSirov/lj4/IzaMqHitbOqx8qqUpsTghcb9DUnNEg=";
  };

  cedSrc = fetchFromGitHub {
    owner = pname;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD

    substituteInPlace data/CMakeLists.txt \
      --replace "/usr" "$out"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    ffmpeg
    fmt
=======
    ffmpeg_4
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    glew
    glibmm
    glm
    icu
    libepoxy
    librsvg
    libxmlxx
<<<<<<< HEAD
    nlohmann_json
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
