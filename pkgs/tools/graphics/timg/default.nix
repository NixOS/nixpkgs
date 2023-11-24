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

  src = fetchFromGitHub {
    owner = "hzeller";
    repo = "timg";
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

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DTIMG_VERSION_FROM_GIT=Off"
    "-DWITH_VIDEO_DECODING=On"
    "-DWITH_VIDEO_DEVICE=On"
    "-DWITH_OPENSLIDE_SUPPORT=On"
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
