{stdenv, fetchurl, alsaLib, gettext, ncurses, libsamplerate}:

stdenv.mkDerivation rec {
  name = "alsa-oss-1.0.25";

  src = fetchurl {
    url = "ftp://ftp.alsa-project.org/pub/oss-lib/${name}.tar.bz2";
    # url = "http://alsa.cybermirror.org/oss-lib/${name}.tar.bz2";
    sha256 = "ed823b8e42599951d896c1709615d4cf7cb1cb3a7c55c75ccee82e24ccaf28e3";
  };

  buildInputs = [ alsaLib ncurses libsamplerate ];
  buildNativeInputs = [ gettext ];

  configureFlags = "--disable-xmlto";

  installFlags = "ASOUND_STATE_DIR=$(TMPDIR)/dummy";

  preConfigure =
    ''
    '';

  meta = {
    description = "ALSA, the Advanced Linux Sound Architecture alsa-oss emulation";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    homepage = http://www.alsa-project.org/;
  };
}
