{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, graphicsmagick, libjpeg
, ffmpeg, zlib, libexif, openslide }:

stdenv.mkDerivation rec {
  pname = "timg";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "timg";
    rev = "v${version}";
    sha256 = "sha256-YqcPTgStevUkl4grgaOLK8v1vbgFNgc7MfkMB07KDqo=";
  };

  buildInputs = [ graphicsmagick ffmpeg libexif libjpeg openslide zlib ];

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DTIMG_VERSION_FROM_GIT=Off"
    "-DWITH_VIDEO_DECODING=On"
    "-DWITH_VIDEO_DEVICE=On"
    "-DWITH_OPENSLIDE_SUPPORT=On"
  ];

  meta = with lib; {
    homepage = "https://timg.sh/";
    description = "A terminal image and video viewer";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ hzeller ];
  };
}
