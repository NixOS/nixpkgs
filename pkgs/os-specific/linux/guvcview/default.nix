{ stdenv, fetchgit, intltool, autoreconfHook, gettext, pkgconfig
, gtk3, portaudio, libpng, SDL, ffmpeg, udev, libusb1, libv4l, alsaLib }:

stdenv.mkDerivation rec {
  version = "1.7.2";
  rev = "ab84b0b1ed358f0504e1218a0ef792a02b307af8";
  name = "guvcview-${version}_${rev}";

  src = fetchgit {
    inherit rev;
    url = "git://git.code.sf.net/p/guvcview/git-master";
    sha256 = "08cpbxq3dh2mlsgzk5dj3vfrgap4q281n9h6xzpbsvyifcj1a9n1";
  };

  buildInputs =
    [ SDL
      alsaLib
      autoreconfHook
      ffmpeg
      gtk3
      intltool
      libusb1
      libv4l
      pkgconfig
      portaudio
      udev
    ];

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
