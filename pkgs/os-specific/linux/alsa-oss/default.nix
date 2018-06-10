{stdenv, fetchurl, alsaLib, gettext, ncurses, libsamplerate}:

stdenv.mkDerivation rec {
  name = "alsa-oss-1.1.6";

  src = fetchurl {
    urls = [
      "ftp://ftp.alsa-project.org/pub/oss-lib/${name}.tar.bz2"
      "http://alsa.cybermirror.org/oss-lib/${name}.tar.bz2"
    ];
    sha256 = "1sj512wyci5qv8cisps96xngh7y9r5mv18ybqnazy18zwr1zgly3";
  };

  buildInputs = [ alsaLib ncurses libsamplerate ];
  nativeBuildInputs = [ gettext ];

  configureFlags = "--disable-xmlto";

  installFlags = "ASOUND_STATE_DIR=$(TMPDIR)/dummy";

  preConfigure =
    ''
    '';

  meta = {
    homepage = http://www.alsa-project.org/;
    description = "ALSA, the Advanced Linux Sound Architecture alsa-oss emulation";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    platforms = stdenv.lib.platforms.linux;
  };
}
