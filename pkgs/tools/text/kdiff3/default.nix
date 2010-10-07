{ stdenv, fetchurl, cmake, qt4, perl, kdelibs, kdebase, automoc4, phonon, gettext}:

stdenv.mkDerivation {
  name = "kdiff3-0.9.95";
  src = fetchurl {
    url = http://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.95/kdiff3-0.9.95.tar.gz;
    sha256 = "0372cebc8957f256a98501a4ac3c3634c7ecffb486ece7e7819c90d876202f0f";   
  };

  cmakeFlags = [ "-DGETTEXT_INCLUDE_DIR=${gettext}/include" ];

  # kdebase allows having a konqueror plugin built
  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon gettext kdebase ];

  meta = {
    homepage = http://kdiff3.sourceforge.net/;
    license = "GPLv2+";
    description = "Compares and merges 2 or 3 files or directories";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
