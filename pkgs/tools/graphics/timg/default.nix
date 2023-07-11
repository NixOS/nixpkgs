{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, ffmpeg
, graphicsmagick
, libdeflate
, libexif
, libjpeg
, libsixel
, openslide
}:

stdenv.mkDerivation rec {
  pname = "timg";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "timg";
    rev = "v${version}";
    hash = "sha256-1zv5+62roS0iSVXa1QXGKuO0Qd6D3e3tZD2HZ5czRRk=";
  };

  buildInputs = [
    ffmpeg
    graphicsmagick
    libdeflate
    libexif
    libjpeg
    libsixel
    openslide
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DTIMG_VERSION_FROM_GIT=Off"
    "-DWITH_VIDEO_DECODING=On"
    "-DWITH_VIDEO_DEVICE=On"
    "-DWITH_OPENSLIDE_SUPPORT=On"
    "-DWITH_LIBSIXEL=On"
  ];

  meta = with lib; {
    homepage = "https://timg.sh/";
    description = "A terminal image and video viewer";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ hzeller ];
  };
}
