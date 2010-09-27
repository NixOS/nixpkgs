{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cabextract-1.3";
  src = fetchurl {
    url = meta.homepage + name + ".tar.gz";
    sha256 = "00f0qcrz9f2gwvm98qglbrjpwrzwrfdgh0hck6im93dl6lx3hr6l";
  };

  meta = {
    homepage = http://www.cabextract.org.uk/;
    description = "Free Software for extracting Microsoft cabinet files";
    platforms = stdenv.lib.platforms.all;
  };
}
