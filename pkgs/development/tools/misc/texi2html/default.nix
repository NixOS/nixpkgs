{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "texi2html-1.82";

  src = fetchurl {
    url = "http://www.very-clever.com/download/nongnu/texi2html/${name}.tar.bz2";
    sha256 = "1wdli2szkgm3l0vx8rf6lylw0b0m47dlz9iy004n928nqkzix76n";
  };

  buildInputs = [perl];

  meta = { 
    description = "Perl script which converts Texinfo source files to HTML output";
    homepage = http://www.nongnu.org/texi2html/;
    license = "GPLv2";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
