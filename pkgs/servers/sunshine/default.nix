{ lib
, stdenv
, fetchFromGitHub
, cmake
, avahi
, libevdev
, libpulseaudio
, xorg
, libxcb
, openssl
, libopus
, ffmpeg-full
, boost
, pkg-config
, libdrm
, wayland
, libffi
, libcap
, mesa
, cudaSupport ? false
, cudaPackages ? {}
}:

stdenv.mkDerivation rec {
  pname = "sunshine";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "LizardByte";
    repo = "Sunshine";
    rev = "v${version}";
    sha256 = "sha256-SB2DAOYf2izIwwRWEw2wt5L5oCDbb6YOqXw/z/PD1pQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals cudaSupport [
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    avahi
    ffmpeg-full
    libevdev
    libpulseaudio
    xorg.libX11
    libxcb
    xorg.libXfixes
    xorg.libXrandr
    xorg.libXtst
    openssl
    libopus
    boost
    libdrm
    wayland
    libffi
    libevdev
    libcap
    libdrm
    mesa
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
  ];

  CXXFLAGS = [
    "-Wno-format-security"
  ];
  CFLAGS = [
    "-Wno-format-security"
  ];

  cmakeFlags = [
    "-D" "FFMPEG_LIBRARIES=${ffmpeg-full}/lib"
    "-D" "FFMPEG_INCLUDE_DIRS=${ffmpeg-full}/include"
    "-D" "LIBAVCODEC_INCLUDE_DIR=${ffmpeg-full}/include"
    "-D" "LIBAVCODEC_LIBRARIES=${ffmpeg-full}/lib/libavcodec.so"
    "-D" "LIBAVDEVICE_INCLUDE_DIR=${ffmpeg-full}/include"
    "-D" "LIBAVDEVICE_LIBRARIES=${ffmpeg-full}/lib/libavdevice.so"
    "-D" "LIBAVFORMAT_INCLUDE_DIR=${ffmpeg-full}/include"
    "-D" "LIBAVFORMAT_LIBRARIES=${ffmpeg-full}/lib/libavformat.so"
    "-D" "LIBAVUTIL_INCLUDE_DIR=${ffmpeg-full}/include"
    "-D" "LIBAVUTIL_LIBRARIES=${ffmpeg-full}/lib/libavutil.so"
    "-D" "LIBSWSCALE_LIBRARIES=${ffmpeg-full}/lib/libswscale.so"
    "-D" "LIBSWSCALE_INCLUDE_DIR=${ffmpeg-full}/include"
  ];

  postPatch = ''
    # Don't force the need for a static boost, fix hardcoded libevdev path
    substituteInPlace CMakeLists.txt \
      --replace 'set(Boost_USE_STATIC_LIBS ON)' '# set(Boost_USE_STATIC_LIBS ON)' \
      --replace '/usr/include/libevdev-1.0' '${libevdev}/include/libevdev-1.0'

    # fix libgbm path
    substituteInPlace src/platform/linux/graphics.cpp \
      --replace 'handle = dyn::handle({ "libgbm.so.1", "libgbm.so" });' 'handle = dyn::handle({ "${mesa}/lib/libgbm.so.1", "${mesa}/lib/libgbm.so" });'

    # fix avahi path
    substituteInPlace src/platform/linux/publish.cpp \
      --replace 'handle = dyn::handle({ "libavahi-client.so.3", "libavahi-client.so" });' 'handle = dyn::handle({ "${avahi}/lib/libavahi-client.so.3", "${avahi}/lib/libavahi-client.so" });' \
      --replace 'handle = dyn::handle({ "libavahi-common.so.3", "libavahi-common.so" });' 'handle = dyn::handle({ "${avahi}/lib/libavahi-common.so.3", "${avahi}/lib/libavahi-common.so" });'
  '';

  meta = with lib; {
    description = "Sunshine is a Game stream host for Moonlight.";
    homepage = "https://docs.lizardbyte.dev/projects/sunshine/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.linux;
  };
}
