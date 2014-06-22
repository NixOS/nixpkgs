{ stdenv, fetchurl, perl /*, xmlto */}:

stdenv.mkDerivation {
  name = "colordiff-1.0.13";

  src = fetchurl {
    url = http://www.colordiff.org/colordiff-1.0.13.tar.gz;
    sha256 = "0akcz1p3klsjnhwcqdfq4grs6paljc5c0jzr3mqla5f862hhaa6f";
  };

  buildInputs = [ perl /* xmlto */ ];

  dontBuild = 1; # do not build doc yet.

  installPhase = ''make INSTALL_DIR=/bin MAN_DIR=/share/man/man1 DESTDIR="$out" install'';

  meta = with stdenv.lib; {
    description = "Wrapper for 'diff' that produces the same output but with pretty 'syntax' highlighting";
    homepage = http://www.colordiff.org/;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
