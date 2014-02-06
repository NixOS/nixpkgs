{ stdenv, fetchgit, intltool, autoreconfHook, gettext, pkgconfig,
  gtk3, portaudio, libpng, SDL, ffmpeg, udev, libusb1, libv4l, alsaLib }:
stdenv.mkDerivation {
  name = "guvcview";
  src = fetchgit {
    url = "git://git.code.sf.net/p/guvcview/git-master";
    rev = "ab84b0b1ed358f0504e1218a0ef792a02b307af8";
  };

  buildInputs = [ autoreconfHook gtk3 intltool pkgconfig 
                  SDL portaudio ffmpeg ffmpeg udev libusb1 libv4l alsaLib ];
  preConfigure = ''
    ./bootstrap.sh
  '';

  meta = {
    description = "A simple interface for devices supported by the linux UVC driver";
    homepage = http://guvcview.sourceforge.net;
    maintainers = [ stdenv.lib.maintainers.coconnor ];
    platforms = stdenv.lib.platforms.linux;
  };
}
