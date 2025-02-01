{ config
, lib, stdenv
, fetchurl
, intltool
, pkg-config
, portaudio
, SDL2
, ffmpeg_4
, udev
, libusb1
, libv4l
, alsa-lib
, gsl
, libpng
, sfml
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux
, libpulseaudio ? null
, useQt ? false
, qtbase ? null
, wrapQtAppsHook ? null
# can be turned off if used as a library
, useGtk ? true
, gtk3 ? null
, wrapGAppsHook3 ? null
}:

assert pulseaudioSupport -> libpulseaudio != null;

stdenv.mkDerivation rec {
  version = "2.0.6";
  pname = "guvcview";

  src = fetchurl {
    url = "mirror://sourceforge/project/guvcview/source/guvcview-src-${version}.tar.gz";
    sha256 = "11byyfpkcik7wvf2qic77zjamfr2rhji97dpj1gy2fg1bvpiqf4m";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
  ]
    ++ lib.optionals (useGtk) [ wrapGAppsHook3 ]
    ++ lib.optionals (useQt) [ wrapQtAppsHook ]
  ;

  buildInputs = [
    SDL2
    alsa-lib
    ffmpeg_4
    libusb1
    libv4l
    portaudio
    udev
    gsl
    libpng
    sfml
  ]
    ++ lib.optionals (pulseaudioSupport) [ libpulseaudio ]
    ++ lib.optionals (useGtk) [ gtk3 ]
    ++ lib.optionals (useQt) [
      qtbase
    ]
  ;
  configureFlags = [
    "--enable-sfml"
  ]
    ++ lib.optionals (useGtk) [ "--enable-gtk3" ]
    ++ lib.optionals (useQt) [ "--enable-qt5" ]
  ;

  meta = with lib; {
    description = "A simple interface for devices supported by the linux UVC driver";
    mainProgram = "guvcview";
    homepage = "https://guvcview.sourceforge.net";
    maintainers = [ maintainers.coconnor ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
