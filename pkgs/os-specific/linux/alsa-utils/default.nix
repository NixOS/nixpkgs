{stdenv, fetchurl, alsaLib, gettext, ncurses, libsamplerate, pciutils, fftw}:

stdenv.mkDerivation rec {
  name = "alsa-utils-${version}";
  version = "1.1.8";

  src = fetchurl {
    url = "mirror://alsa/utils/${name}.tar.bz2";
    sha256 = "1kx45yhrxai3k595yyqs4wj0p2n5b0c9mf0k36ljjf1bj8lgb6zx";
  };

  patchPhase = ''
    substituteInPlace alsa-info/alsa-info.sh \
      --replace "which" "type -p" \
      --replace "lspci" "${pciutils}/bin/lspci"
  '';
  nativeBuildInputs = [ gettext ];
  buildInputs = [ alsaLib ncurses libsamplerate fftw ];

  configureFlags = [ "--disable-xmlto" "--with-udev-rules-dir=$(out)/lib/udev/rules.d" ];

  installFlags = "ASOUND_STATE_DIR=$(TMPDIR)/dummy";

  meta = with stdenv.lib; {
    homepage = http://www.alsa-project.org/;
    description = "ALSA, the Advanced Linux Sound Architecture utils";
    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
