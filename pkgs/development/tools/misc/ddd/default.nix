{stdenv, fetchurl, lesstif, ncurses, libX11, libXt}:

stdenv.mkDerivation rec {
  name = "ddd-3.3.11";
  src = fetchurl {
    url = "mirror://gnu/ddd/${name}.tar.gz";
    sha256 = "a555d76e1d4d5fa092b190ffb99cdde8880131c063e4b53435df3a022ed4d3da";
  };
  buildInputs = [lesstif ncurses libX11 libXt];
	configureFlags = "--with-x";
	meta = {
	  homepage = http://www.gnu.org/software/ddd;
		description = "Graphical front-end for command-line debuggers";
		license = "GPLv2";
	};
}
