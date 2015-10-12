{stdenv, fetchurl, alsaLib, gettext, ncurses, libsamplerate, gnumake, pkgconfig, gtk}:

stdenv.mkDerivation rec {
  name = "alsa-tools-${version}";
  version = "1.0.29";

  src = fetchurl {
    urls = [
      "ftp://ftp.alsa-project.org/pub/tools/${name}.tar.bz2"
      "http://alsa.cybermirror.org/tools/${name}.tar.bz2"
    ];
    sha256 = "1lgvyb81md25s9ciswpdsbibmx9s030kvyylf0673w3kbamz1awl";
  };

  phases = "unpackPhase configurePhase buildPhase fixupPhase installPhase";

  buildInputs = [ gettext alsaLib ncurses libsamplerate gnumake pkgconfig gtk ];

  configurePhase = ''
    cd envy24control; ./configure --prefix="$out"; cd -
  '';

  buildPhase = ''
    cd envy24control; make; cd -
  '';

  installPhase = ''
    cd envy24control; make install; cd -
  '';

  
  # patchPhase = "patchShebangs";
  patchPhase = ''
    patchShebangs gitcompile 
    patchShebangs hdajackretask/gitcompile 
    patchShebangs echomixer/gitcompile 
    patchShebangs hwmixvolume/gitcompile 
    patchShebangs usx2yloader/gitcompile 
    patchShebangs sb16_csp/gitcompile 
    patchShebangs pcxhrloader/gitcompile 
    patchShebangs as10k1/gitcompile 
    patchShebangs hdspconf/gitcompile 
    patchShebangs sscape_ctl/gitcompile 
    patchShebangs hdsploader/gitcompile 
    patchShebangs rmedigicontrol/gitcompile 
    patchShebangs vxloader/gitcompile 
    patchShebangs us428control/gitcompile 
    patchShebangs mixartloader/gitcompile 
    patchShebangs hdspmixer/gitcompile 
    patchShebangs seq/sbiload/gitcompile 
    patchShebangs seq/gitcompile 
    patchShebangs gitcompile qlo10k1/gitcompile 
    patchShebangs ld10k1/gitcompile 
    patchShebangs hda-verb/gitcompile 
    patchShebangs envy24control/gitcompile
  '';

  # configureFlags = "--disable-xmlto --with-udev-rules-dir=$(out)/lib/udev/rules.d";

  # installFlags = "ASOUND_STATE_DIR=$(TMPDIR)/dummy";

  meta = {
    homepage = http://www.alsa-project.org/;
    description = "ALSA, the Advanced Linux Sound Architecture utils";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ "Florian Paul Schmidt <mista.tapas@gmx.net>" ];
  };
}
