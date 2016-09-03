{ stdenv, buildEnv, fetchurl
, libjack2, alsaLib, libpulseaudio
, faac, lame, libogg, libopus, libvorbis, libsamplerate
}:

let
  oggEnv = buildEnv {
    name = "env-darkice-ogg";
    paths = [
      libopus.dev libopus libvorbis.dev libvorbis libogg.dev libogg
    ];
  };

  darkiceEnv = buildEnv {
    name = "env-darkice";
    paths = [
      lame.out lame.lib libpulseaudio libpulseaudio.dev alsaLib alsaLib.dev libsamplerate.out libsamplerate.dev
    ];
  };

in stdenv.mkDerivation rec {
  name = "darkice-${version}";
  version = "1.3";

  src = fetchurl {
    url = "mirror://sourceforge/darkice/${version}/darkice-${version}.tar.gz";
    sha256 = "1rlxds7ssq7nk2in4s46xws7xy9ylxsqgcz85hxjgh17lsm0y39c";
  };

  configureFlags = [
    "--with-alsa-prefix=${darkiceEnv}"
    "--with-faac-prefix=${faac}"
    "--with-jack-prefix=${libjack2}"
    "--with-lame-prefix=${darkiceEnv}"
    "--with-opus-prefix=${oggEnv}"
    "--with-pulseaudio-prefix=${darkiceEnv}"
    "--with-samplerate-prefix=${darkiceEnv}"
    "--with-vorbis-prefix=${oggEnv}"
#    "--with-aacplus-prefix=${aacplus}" ### missing: aacplus
#    "--with-twolame-prefix=${twolame}" ### missing: twolame
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
