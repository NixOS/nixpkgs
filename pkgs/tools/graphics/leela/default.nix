{ stdenv, fetchFromGitHub, pkgconfig, poppler }:

stdenv.mkDerivation {
  name = "leela-12.fe7a35a";

  src = fetchFromGitHub {
    owner = "TrilbyWhite";
    repo = "Leela";
    rev = "576a60185b191d3a3030fef10492fe32d2125563";
    sha256 = "1k6n758r9dhjmc1pnpk6qzpg0q7pkq2hf18z3b0s2z198jpkg9s3";
  };

  buildInputs = [ pkgconfig poppler ];

  installFlags = [ "PREFIX=$(out)" "MANDIR=$(out)/share/man" ];

  meta = {
    description = "CLI frontend to the poppler-glib libary of PDF tools";
    homepage = https://github.com/TrilbyWhite/Leela;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.puffnfresh ];
    platforms = stdenv.lib.platforms.linux;
  };
}
