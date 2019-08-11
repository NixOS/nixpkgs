{ stdenv, fetchurl, fetchpatch
, pkgconfig, libtool, intltool
, libXmu
, lua
, agg, alsaLib, soundtouch, openal
, desktop-file-utils
, gtk2, gtkglext, libglade, pangox_compat
, libGLU, libpcap, SDL, zziplib }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "desmume-${version}";
  version = "0.9.11";

  src = fetchurl {
    url = "mirror://sourceforge/project/desmume/desmume/${version}/${name}.tar.gz";
    sha256 = "15l8wdw3q61fniy3h93d84dnm6s4pyadvh95a0j6d580rjk4pcrs";
  };

  patches = [
    (fetchpatch {
      name = "gcc6_fixes.patch";
      url = "https://anonscm.debian.org/viewvc/pkg-games/packages/trunk/desmume/debian/patches/gcc6_fixes.patch?revision=15925";
      sha256 = "0j3fmxz0mfb3f4biks03pyz8f9hy958ks6qplisl60rzq9v9qpks";
     })
  ];

  CXXFLAGS = "-fpermissive";

  buildInputs =
  [ pkgconfig libtool intltool libXmu lua agg alsaLib soundtouch
    openal desktop-file-utils gtk2 gtkglext libglade pangox_compat
    libGLU libpcap SDL zziplib ];

  configureFlags = [
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
# TODO: investigate glade
