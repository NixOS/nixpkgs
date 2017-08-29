{ stdenv, fetchgit
, autoreconfHook , pkgconfig, libtool, intltool
, lua , libXmu, agg, alsaLib, soundtouch
, gtk2, gtkglext, libglade, pangox_compat
, openal , mesa_noglu, mesa_glu
, SDL, zziplib, libpcap
, desktop_file_utils }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "desmume-${version}";
  version = "0.9.11-git-2017-09-16";

  src = fetchgit {
    url = "https://github.com/TASVideos/desmume";
    rev = "8f2c85fe86ec48da89f16f2830dea5560b7a029c";
    sha256 = "1fh6h96wd7181nbckr07lq59n89r7i3g2nk48v6yym5qcjmgv53c";
    fetchSubmodules = true;
  };

  buildInputs =
  [ autoreconfHook pkgconfig
    libtool intltool lua libXmu agg alsaLib soundtouch
    gtk2 gtkglext libglade pangox_compat openal
    mesa_glu mesa_noglu.osmesa SDL zziplib libpcap
    desktop_file_utils ];    

  hardeningDisable = [ "format" ];
  
  configureFlags = [
    "--enable-osmesa"
    "--enable-glx"
    "--enable-openal"
    "--enable-glade"
    "--disable-hud"
    "--disable-wifi"
  ];

  postUnpack = ''
    export sourceRoot=$sourceRoot/desmume/src/frontend/posix/
  '';
  
  meta = {
    description = "An open-source Nintendo DS emulator";
    longDescription = ''
      DeSmuME is a freeware emulator for the NDS roms & Nintendo DS
      Lite games created by YopYop156. It supports many homebrew nds
      rom demoes as well as a handful of Wireless Multiboot demo nds
      roms. DeSmuME is also able to emulate nearly all of the
      commercial nds rom titles which other DS Emulators aren't.
    '';
    homepage = http://www.desmume.com;
    license = licenses.gpl1Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
    broken = true;
  };
}
# TODO:
# - According to Arch, HUD causes SIGSEGV in GTK version;
# - CLI version also SIGSEGVs
# - Only desmume-glade really works
# - '--disable-hud' doesn't work; it is completely ignored
