{ config
, lib, stdenv
, fetchurl
, intltool
, pkg-config
, portaudio
, SDL2
, ffmpeg_7
, udev
, libusb1
, libv4l
, alsa-lib
, gsl
, libpng
, sfml
, pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux
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
  version = "2.1.0";
  pname = "guvcview";

  src = fetchurl {
    url = "mirror://sourceforge/project/guvcview/source/guvcview-src-${version}.tar.bz2";
    hash = "sha256-PZPkyfq40aepveGm278E1s+dNHwTS1EotFhqHZC2PPs=";
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
    ffmpeg_7
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
    description = "Simple interface for devices supported by the linux UVC driver";
    mainProgram = "guvcview";
    homepage = "https://guvcview.sourceforge.net";
    maintainers = [ maintainers.coconnor ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
