{ stdenv, fetchurl, perl /*, xmlto */}:

stdenv.mkDerivation rec {
  name = "colordiff-1.0.18";

  src = fetchurl {
    urls = [
      "http://www.colordiff.org/${name}.tar.gz"
      "http://www.colordiff.org/archive/${name}.tar.gz"
    ];
    sha256 = "1q6n60n4b9fnzccxyxv04mxjsql4ddq17vl2c74ijvjdhpcfrkr9";
  };

  buildInputs = [ perl /* xmlto */ ];

  dontBuild = 1; # do not build doc yet.

  installPhase = ''make INSTALL_DIR=/bin MAN_DIR=/share/man/man1 DESTDIR="$out" install'';

  meta = with stdenv.lib; {
    description = "Wrapper for 'diff' that produces the same output but with pretty 'syntax' highlighting";
    homepage = https://www.colordiff.org/;
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ nckx ];
  };
}
