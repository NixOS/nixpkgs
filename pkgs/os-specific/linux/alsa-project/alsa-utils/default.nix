{lib, stdenv, fetchurl, alsa-lib, gettext, makeWrapper, ncurses, libsamplerate, pciutils, which, fftw}:

stdenv.mkDerivation rec {
  pname = "alsa-utils";
  version = "1.2.5.1";

  src = fetchurl {
    url = "mirror://alsa/utils/${pname}-${version}.tar.bz2";
    sha256 = "sha256-nBaa43pJKV+bl7kqzncoA9r2tlEKGVdOC3j4flYhGNA=";
  };

  nativeBuildInputs = [ gettext makeWrapper ];
  buildInputs = [ alsa-lib ncurses libsamplerate fftw ];

  configureFlags = [ "--disable-xmlto" "--with-udev-rules-dir=$(out)/lib/udev/rules.d" ];

  installFlags = [ "ASOUND_STATE_DIR=$(TMPDIR)/dummy" ];

  postFixup = ''
    mv $out/bin/alsa-info.sh $out/bin/alsa-info
    wrapProgram $out/bin/alsa-info --prefix PATH : "${lib.makeBinPath [ which pciutils ]}"
  '';

  meta = with lib; {
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
