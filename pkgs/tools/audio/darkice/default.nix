{ stdenv, buildEnv, fetchurl, alsaLib, faac, libjack2, lame, libogg, libopus, libpulseaudio, libsamplerate, libvorbis }:

let
  oggEnv = buildEnv {
    name = "env-darkice-ogg";
    paths = [
      libopus libvorbis libogg
    ];
  };

in stdenv.mkDerivation rec {
  name = "darkice-${version}";
  version = "1.2";

  src = fetchurl {
    url = "mirror://sourceforge/darkice/${version}/darkice-${version}.tar.gz";
    sha256 = "0m5jzmja7a9x15zl1634bhxrg3rccph9rkar0rmz6wlw5nzakyxk";
  };

  configureFlags = [
    "--with-alsa-prefix=${alsaLib}"
    "--with-faac-prefix=${faac}"
    "--with-jack-prefix=${libjack2}"
    "--with-lame-prefix=${lame}"
    "--with-opus-prefix=${oggEnv}"
    "--with-pulseaudio-prefix=${libpulseaudio}"
    "--with-samplerate-prefix=${libsamplerate}"	
    "--with-vorbis-prefix=${oggEnv}"
#    "--with-aacplus-prefix=${aacplus}" ### missing: aacplus
#    "--with-twolame-prefix=${twolame}" ### missing: twolame
  ];

  meta = {
    homepage = http://darkice.org/;
    description = "Live audio streamer";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ ikervagyok ];
  };
}
