{
  config,
  lib,
  stdenv,
  fetchurl,
  cmake,
  intltool,
  pkg-config,
  portaudio,
  SDL2,
  ffmpeg,
  udev,
  libusb1,
  libv4l,
  alsa-lib,
  gsl,
  libpng,
  sfml_2,
  pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  libpulseaudio,
  useQt ? false,
  qtbase ? null,
  wrapQtAppsHook ? null,
  # can be turned off if used as a library
  useGtk ? true,
  gtk3,
  wrapGAppsHook3 ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guvcview";
  version = "2.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/guvcview/source/guvcview-src-${finalAttrs.version}.tar.bz2";
    hash = "sha256-0q3HznYpYehTw+FrURutYVBEktEvPi634w2kovet5a8=";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
    cmake
  ]
  ++ lib.optionals useGtk [ wrapGAppsHook3 ]
  ++ lib.optionals useQt [ wrapQtAppsHook ];

  buildInputs = [
    SDL2
    alsa-lib
    ffmpeg
    libusb1
    libv4l
    portaudio
    udev
    gsl
    libpng
    sfml_2
  ]
  ++ lib.optionals pulseaudioSupport [ libpulseaudio ]
  ++ lib.optionals useGtk [ gtk3 ]
  ++ lib.optionals useQt [
    qtbase
  ];

  configureFlags = [
    "--enable-sfml"
  ]
  ++ lib.optionals useGtk [ "--enable-gtk3" ]
  ++ lib.optionals useQt [ "--enable-qt5" ];

  meta = {
    description = "Simple interface for devices supported by the linux UVC driver";
    mainProgram = "guvcview";
    homepage = "https://guvcview.sourceforge.net";
    maintainers = [ lib.maintainers.coconnor ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
