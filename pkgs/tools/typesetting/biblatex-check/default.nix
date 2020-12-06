{ stdenv, fetchFromGitHub, python }:

stdenv.mkDerivation {
  pname = "biblatex-check";
  version = "2019-11-09";

  src = fetchFromGitHub {
    owner = "Pezmc";
    repo = "BibLatex-Check";
    rev = "2db50bf94d1480f37edf1b3619e73baf4ef85938";
    sha256 = "1bq0yqckhssazwkivipdjmn1jpsf301i4ppyl88qhc5igx39wg25";
  };

  buildInputs = [ python ];

  installPhase = ''
    install -Dm755 biblatex_check.py $out/bin/biblatex-check
  '';

  meta = with stdenv.lib; {
    description = "Python2/3 script for checking BibLatex .bib files";
    homepage = "https://github.com/Pezmc/BibLatex-Check";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
