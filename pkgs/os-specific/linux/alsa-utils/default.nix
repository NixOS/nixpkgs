{stdenv, fetchurl, alsaLib, gettext, ncurses, libsamplerate}:

stdenv.mkDerivation rec {
  name = "alsa-utils-1.0.27";

  src = fetchurl {
    # url = "ftp://ftp.alsa-project.org/pub/utils/${name}.tar.bz2";
    url = "http://alsa.cybermirror.org/utils/${name}.tar.bz2";
    sha256 = "1vssljbdzf0psqhhd7w9m9mzb0sl2kgx9fagkja25sqw6ivwsxkg";
  };

  buildInputs = [ alsaLib ncurses libsamplerate ];
  nativeBuildInputs = [ gettext ];

  configureFlags = "--disable-xmlto --with-udev-rules-dir=$(out)/lib/udev/rules.d";

  installFlags = "ASOUND_STATE_DIR=$(TMPDIR)/dummy";

  preConfigure =
    ''
      # Ensure that ‘90-alsa-restore.rules.in’ gets rebuilt.
      rm alsactl/90-alsa-restore.rules
    '';

  meta = {
    description = "ALSA, the Advanced Linux Sound Architecture utils";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    homepage = http://www.alsa-project.org/;
  };
}
