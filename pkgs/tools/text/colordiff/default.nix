{ stdenv, fetchurl, perl /*, xmlto */}:

stdenv.mkDerivation rec {
  name = "colordiff-1.0.19";

  src = fetchurl {
    urls = [
      "https://www.colordiff.org/${name}.tar.gz"
      "http://www.colordiff.org/archive/${name}.tar.gz"
    ];
    sha256 = "069vzzgs7b44bmfh3ks2psrdb26s1w19gp9w4xxbgi7nhx6w3s26";
  };

  buildInputs = [ perl /* xmlto */ ];

  dontBuild = 1; # do not build doc yet.

  installPhase = ''make INSTALL_DIR=/bin MAN_DIR=/share/man/man1 DESTDIR="$out" install'';

  meta = with stdenv.lib; {
    description = "Wrapper for 'diff' that produces the same output but with pretty 'syntax' highlighting";
    homepage = "https://www.colordiff.org/";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
