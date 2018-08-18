{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "bibtex2html-${version}";
  version = "1.98";

  src = fetchurl {
    url = https://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.98.tar.gz;
    sha256 = "1mh6hxmc9qv05hgjc11m2zh5mk9mk0kaqp59pny18ypqgfws09g9";
  };

  buildInputs = [ ocaml ];

  meta = with stdenv.lib; {
    description = "A collection of tools for translating from BibTeX to HTML";
    homepage = https://www.lri.fr/~filliatr/bibtex2html/;
    license = licenses.gpl2;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.scolobb ];
  };
}
