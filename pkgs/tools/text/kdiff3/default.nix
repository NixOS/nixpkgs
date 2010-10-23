{ stdenv, fetchurl, cmake, qt4, perl, kdelibs, kdebase, automoc4, phonon, gettext}:

stdenv.mkDerivation rec {
  name = "kdiff3-0.9.95";
  src = fetchurl {
    url = "mirror://sourceforge/kdiff3/${name}.tar.gz";
    sha256 = "03rg41vdi44wh7kygv46nkzyrirl6qyar901hnlmdwjpi6ycwwh3";
  };

  # kdebase allows having a konqueror plugin built
  buildInputs = [ cmake qt4 perl kdelibs automoc4 phonon gettext kdebase ];

  # Adjust the version of the DocBook XML to 4.2 ( so that it validates ).
  patches = [ ./adjust-docbook-xml-version-to-4.2.patch ];

  meta = {
    homepage = http://kdiff3.sourceforge.net/;
    license = "GPLv2+";
    description = "Compares and merges 2 or 3 files or directories";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
