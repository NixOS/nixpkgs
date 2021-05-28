{stdenv, fetchurl, alsaLib, gettext, makeWrapper, ncurses, libsamplerate, pciutils, which, fftw}:

stdenv.mkDerivation rec {
  pname = "alsa-utils";
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://alsa/utils/${pname}-${version}.tar.bz2";
    sha256 = "1ai1z4kf91b1m3qrpwqkc1af5vm2fkdkknqv95xdwf19q94aw6gz";
  };

  nativeBuildInputs = [ gettext ];
  buildInputs = [ makeWrapper alsaLib ncurses libsamplerate fftw ];

  configureFlags = [ "--disable-xmlto" "--with-udev-rules-dir=$(out)/lib/udev/rules.d" ];

  installFlags = [ "ASOUND_STATE_DIR=$(TMPDIR)/dummy" ];

  postFixup = ''
    wrapProgram $out/bin/alsa-info.sh --prefix PATH : "${stdenv.lib.makeBinPath [ which pciutils ]}"
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.alsa-project.org/";
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
