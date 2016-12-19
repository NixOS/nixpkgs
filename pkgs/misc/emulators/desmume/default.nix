{ stdenv, fetchurl
, pkgconfig, libtool, intltool
, libXmu
, lua
, agg, alsaLib, soundtouch, openal
, desktop_file_utils
, gtk2, gtkglext, libglade, pangox_compat
, mesa, mesa_glu, libpcap, SDL, zziplib }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "desmume-${version}";
  version = "0.9.11";

  src = fetchurl {
    url = "mirror://sourceforge/project/desmume/desmume/${version}/${name}.tar.gz";
    sha256 = "15l8wdw3q61fniy3h93d84dnm6s4pyadvh95a0j6d580rjk4pcrs";
  };

  buildInputs =
  [ pkgconfig libtool intltool libXmu lua agg alsaLib soundtouch
    openal desktop_file_utils gtk2 gtkglext libglade pangox_compat
    mesa mesa_glu libpcap SDL zziplib ];

  configureFlags = [
    "--disable-osmesa" # Failing on compile step
    "--disable-glade"  # Failing on compile step
    "--enable-openal"
    "--enable-glx"
    "--enable-hud"
    "--enable-wifi" ];

  meta = {
    description = "An open-source Nintendo DS emulator";
    longDescription = ''
      DeSmuME is a freeware emulator for the NDS roms & Nintendo DS
      Lite games created by YopYop156. It supports many homebrew nds
      rom demoes as well as a handful of Wireless Multiboot demo nds
      roms. DeSmuME is also able to emulate nearly all of the
      commercial nds rom titles which other DS Emulators aren't.
    '';
    homepage = http://www.desmume.com ;
    license = licenses.gpl1Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
# TODO: investigate osmesa and glade
