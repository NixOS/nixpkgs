{stdenv, fetchurl, alsaLib, gettext, ncurses, libsamplerate}:

stdenv.mkDerivation rec {
  name = "alsa-utils-1.0.28";

  src = fetchurl {
    urls = [
      "ftp://ftp.alsa-project.org/pub/utils/${name}.tar.bz2"
      "http://alsa.cybermirror.org/utils/${name}.tar.bz2"
    ];
    sha256 = "1k1ach1jv0bf71klj9sqaijnw9wjrjad0g5in6bpfnhjn24lrzzk";
  };

  buildInputs = [ alsaLib ncurses libsamplerate ];
  nativeBuildInputs = [ gettext ];

  configureFlags = "--disable-xmlto --with-udev-rules-dir=$(out)/lib/udev/rules.d";

  installFlags = "ASOUND_STATE_DIR=$(TMPDIR)/dummy";

  meta = {
    homepage = http://www.alsa-project.org/;
    description = "ALSA, the Advanced Linux Sound Architecture utils";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    platforms = stdenv.lib.platforms.linux;
  };
}
