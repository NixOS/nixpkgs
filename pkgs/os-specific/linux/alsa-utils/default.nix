{stdenv, fetchurl, alsaLib, gettext, ncurses, libsamplerate, pciutils, fftw}:

stdenv.mkDerivation rec {
  name = "alsa-utils-${version}";
  version = "1.1.4";

  src = fetchurl {
    urls = [
      "ftp://ftp.alsa-project.org/pub/utils/${name}.tar.bz2"
      "http://alsa.cybermirror.org/utils/${name}.tar.bz2"
    ];
    sha256 = "17cxih9ibjp1193dyd79j50pyfa9dvrs6r9kpwrvzicjvr2110x7";
  };

  patchPhase = ''
    substituteInPlace alsa-info/alsa-info.sh \
      --replace "which" "type -p" \
      --replace "lspci" "${pciutils}/bin/lspci"
  '';
  buildInputs = [ gettext alsaLib ncurses libsamplerate fftw ];

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
    maintainers = [ stdenv.lib.maintainers.AndersonTorres ];
  };
}
