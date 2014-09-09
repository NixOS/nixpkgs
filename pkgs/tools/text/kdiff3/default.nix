{ stdenv, fetchurl, cmake, kdelibs, gettext }:

stdenv.mkDerivation rec {
  name = "kdiff3-0.9.98";
  src = fetchurl {
    url = "mirror://sourceforge/kdiff3/${name}.tar.gz";
    sha256 = "0s6n1whkf5ck2r8782a9l8b736cj2p05and1vjjh7d02pax1lb40";
  };

  buildInputs = [ kdelibs ];
  nativeBuildInputs = [ cmake gettext ];

  meta = {
    homepage = http://kdiff3.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Compares and merges 2 or 3 files or directories";
    maintainers = with stdenv.lib.maintainers; [viric urkud];
    platforms = with stdenv.lib.platforms; linux;
  };
}
