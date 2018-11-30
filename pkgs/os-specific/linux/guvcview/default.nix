{ stdenv, fetchurl, intltool, pkgconfig
, gtk3, portaudio, SDL2, ffmpeg, udev, libusb1, libv4l, alsaLib, gsl
, pulseaudioSupport ? true, libpulseaudio ? null }:

assert pulseaudioSupport -> libpulseaudio != null;

stdenv.mkDerivation rec {
  version = "2.0.5";
  name = "guvcview-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/guvcview/source/guvcview-src-${version}.tar.gz";
    sha256 = "a86beb5993a8449ed3cbcc6ec2a238ef0b90138b6cbe2afab4456d37f44c41a0";
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
