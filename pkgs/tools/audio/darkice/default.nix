{ stdenv, fetchurl, pkgconfig
, libjack2, alsaLib, libpulseaudio
, faac, lame, libogg, libopus, libvorbis, libsamplerate
}:

stdenv.mkDerivation rec {
  name = "darkice-${version}";
  version = "1.3";

  src = fetchurl {
    url = "mirror://sourceforge/darkice/${version}/darkice-${version}.tar.gz";
    sha256 = "1rlxds7ssq7nk2in4s46xws7xy9ylxsqgcz85hxjgh17lsm0y39c";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libopus libvorbis libogg libpulseaudio alsaLib libsamplerate libjack2 lame
  ];

  NIX_CFLAGS_COMPILE = "-fpermissive";

  configureFlags = [
    "--with-faac-prefix=${faac}"
    "--with-lame-prefix=${lame.lib}"
  ];

  patches = [ ./fix-undeclared-memmove.patch ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://darkice.org/;
    description = "Live audio streamer";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ ikervagyok fpletz ];
  };
}
