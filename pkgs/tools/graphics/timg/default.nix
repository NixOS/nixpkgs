<<<<<<< HEAD
{ cmake
, fetchFromGitHub
, ffmpeg
, graphicsmagick
, lib
, libdeflate
, libexif
, libjpeg
, libsixel
, openslide
, pkg-config
, stb
, qoi
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "timg";
  version = "1.5.2";
=======
{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, graphicsmagick, libjpeg
, ffmpeg, zlib, libexif, openslide }:

stdenv.mkDerivation rec {
  pname = "timg";
  version = "1.4.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "timg";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-e2Uy1jvS0+gdhto4Sgz6YlqEqXJ7KGUAA6iuixfvvJg=";
  };

  buildInputs = [
    ffmpeg
    graphicsmagick
    libdeflate
    libexif
    libjpeg
    libsixel
    openslide
    qoi.dev
    stb
  ];
=======
    rev = "v${version}";
    sha256 = "sha256-YqcPTgStevUkl4grgaOLK8v1vbgFNgc7MfkMB07KDqo=";
  };

  buildInputs = [ graphicsmagick ffmpeg libexif libjpeg openslide zlib ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DTIMG_VERSION_FROM_GIT=Off"
    "-DWITH_VIDEO_DECODING=On"
    "-DWITH_VIDEO_DEVICE=On"
    "-DWITH_OPENSLIDE_SUPPORT=On"
<<<<<<< HEAD
    "-DWITH_LIBSIXEL=On"
  ];

  meta = {
    description = "A terminal image and video viewer";
    homepage = "https://timg.sh/";
    license = lib.licenses.gpl2Only;
    mainProgram = "timg";
    maintainers = with lib.maintainers; [ hzeller ];
    platforms = lib.platforms.unix;
  };
})
=======
  ];

  meta = with lib; {
    homepage = "https://timg.sh/";
    description = "A terminal image and video viewer";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ hzeller ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
