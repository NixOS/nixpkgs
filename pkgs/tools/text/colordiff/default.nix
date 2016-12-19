{ stdenv, fetchurl, perl /*, xmlto */}:

stdenv.mkDerivation rec {
  name = "colordiff-1.0.16";

  src = fetchurl {
    urls = [
      "http://www.colordiff.org/${name}.tar.gz"
      "http://www.colordiff.org/archive/${name}.tar.gz"
    ];
    sha256 = "12qkkw13261dra8pg7mzx4r8p9pb0ajb090bib9j1s6hgphwzwga";
  };

  buildInputs = [ perl /* xmlto */ ];

  dontBuild = 1; # do not build doc yet.

  installPhase = ''make INSTALL_DIR=/bin MAN_DIR=/share/man/man1 DESTDIR="$out" install'';

  meta = with stdenv.lib; {
    description = "Wrapper for 'diff' that produces the same output but with pretty 'syntax' highlighting";
    homepage = http://www.colordiff.org/;
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ nckx ];
  };
}
