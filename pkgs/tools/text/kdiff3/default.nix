{ stdenv, fetchurl, cmake, kdelibs, gettext }:

stdenv.mkDerivation rec {
  name = "kdiff3-0.9.96";
  src = fetchurl {
    url = "mirror://sourceforge/kdiff3/${name}.tar.gz";
    sha256 = "14fnflp5ansi7b59h8vn81mb8pdqpbanz0qzyw9sxk2pgp24xrqh";
  };

  buildInputs = [ kdelibs ];
  nativeBuildInputs = [ cmake gettext ];

  meta = {
    homepage = http://kdiff3.sourceforge.net/;
    license = "GPLv2+";
    description = "Compares and merges 2 or 3 files or directories";
    maintainers = with stdenv.lib.maintainers; [viric urkud];
    platforms = with stdenv.lib.platforms; linux;
  };
}
