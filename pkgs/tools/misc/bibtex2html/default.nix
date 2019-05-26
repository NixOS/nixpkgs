{ stdenv, fetchurl, ocaml }:

stdenv.mkDerivation rec {
  name = "bibtex2html-${version}";
  version = "1.99";

  src = fetchurl {
    url = https://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.99.tar.gz;
    sha256 = "07gzrs4lfrkvbn48cgn2gn6c7cx3jsanakkrb2irj0gmjzfxl96j";
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
