{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, pkg-config, graphicsmagick, libjpeg
, ffmpeg, zlib, libexif, openslide }:

stdenv.mkDerivation rec {
  pname = "timg";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "timg";
    rev = "v${version}";
    sha256 = "1gdwg15fywya6k6pajkx86kv2d8k85pmisnq53b02br5i01y4k41";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/hzeller/timg/commit/e9667ea2c811aa9eb399b631aef9bba0d3711834.patch";
      sha256 = "sha256-xvbOcnKqX52wYZlzm4Be9dz8Rq+n3s2kKPFr0Y0igAU=";
      name = "CVE-2022-43151.patch";
    })
  ];

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
