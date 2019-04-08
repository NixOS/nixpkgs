{ config, stdenv, fetchurl, intltool, pkgconfig
, gtk3, portaudio, SDL2, ffmpeg, udev, libusb1, libv4l, alsaLib, gsl
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux, libpulseaudio ? null }:

assert pulseaudioSupport -> libpulseaudio != null;

stdenv.mkDerivation rec {
  version = "2.0.6";
  name = "guvcview-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/guvcview/source/guvcview-src-${version}.tar.gz";
    sha256 = "11byyfpkcik7wvf2qic77zjamfr2rhji97dpj1gy2fg1bvpiqf4m";
  };

  buildInputs =
    [ SDL2
      alsaLib
      ffmpeg
      gtk3
      intltool
      libusb1
      libv4l
      pkgconfig
      portaudio
      udev
      gsl
    ] ++ stdenv.lib.optional pulseaudioSupport libpulseaudio;

  meta = with stdenv.lib; {
    description = "A simple interface for devices supported by the linux UVC driver";
    homepage = http://guvcview.sourceforge.net;
    maintainers = [ maintainers.coconnor ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
