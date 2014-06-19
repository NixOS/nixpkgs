{ stdenv, fetchurl, cmake, kdelibs, gettext }:

stdenv.mkDerivation rec {
  name = "kdiff3-0.9.97";
  src = fetchurl {
    url = "mirror://sourceforge/kdiff3/${name}.tar.gz";
    sha256 = "0ajsnzfr0aqzdiv5wqssxsgfv87v4g5c2zl16264v0cw8jxiddz3";
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
