{stdenv, fetchurl, alsaLib, gettext, ncurses}:

stdenv.mkDerivation rec {
  name = "alsa-utils-1.0.25";
  
  src = fetchurl {
    url = "ftp://ftp.alsa-project.org/pub/utils/${name}.tar.bz2";
    sha256 = "0b1hbdq1bdkbz72zdfy5cgp75jqpysb0mqb0n9wy5gsbccpnlrrf";
  };
  
  buildInputs = [ alsaLib ncurses ];
  buildNativeInputs = [ gettext ];
  
  configureFlags = "--disable-xmlto --with-udev-rules-dir=$(out)/lib/udev/rules.d";

  meta = {
    description = "ALSA, the Advanced Linux Sound Architecture utils";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    homepage = http://www.alsa-project.org/;
  };
}
