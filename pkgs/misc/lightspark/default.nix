{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, curl, zlib, ffmpeg, glew, pcre
<<<<<<< HEAD
, rtmpdump, cairo, boost, SDL2, libjpeg, pango, xz, nasm, llvm, glibmm
=======
, rtmpdump, cairo, boost, SDL2, SDL2_mixer, libjpeg, pango, xz, nasm
, llvm, glibmm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "lightspark";
<<<<<<< HEAD
  version = "0.8.7";
=======
  version = "0.8.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lightspark";
    repo = "lightspark";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-qX/ft9slWTbvuSyi2jB6YC7D7QTtCybL/dTo1dJp3pQ=";
=======
    sha256 = "sha256-/w0cqPIeQC1Oz1teSjMpeiQEI6bIpnyOOu0GoGyi6Kg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i 's/SET(ETCDIR "\/etc")/SET(ETCDIR "etc")/g' CMakeLists.txt
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [
<<<<<<< HEAD
    curl zlib ffmpeg glew pcre rtmpdump cairo boost SDL2 libjpeg pango xz nasm
    llvm glibmm
=======
    curl zlib ffmpeg glew pcre rtmpdump cairo boost SDL2 SDL2_mixer libjpeg
    pango xz nasm llvm glibmm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Open source Flash Player implementation";
    homepage = "https://lightspark.github.io/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jchw ];
    platforms = platforms.linux;
  };
}
