{stdenv, fetchurl, motif, ncurses, libX11, libXt}:

stdenv.mkDerivation rec {
  name = "ddd-3.3.12";
  src = fetchurl {
    url = "mirror://gnu/ddd/${name}.tar.gz";
    sha256 = "0p5nx387857w3v2jbgvps2p6mlm0chajcdw5sfrddcglsxkwvmis";
  };
  buildInputs = [motif ncurses libX11 libXt];
  configureFlags = [ "--with-x" ];

  patches = [ ./gcc44.patch ];

  meta = {
    homepage = http://www.gnu.org/software/ddd;
    description = "Graphical front-end for command-line debuggers";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
