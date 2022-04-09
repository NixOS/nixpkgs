{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname = "biblatex-check";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Pezmc";
    repo = "BibLatex-Check";
    rev = "v${version}";
    sha256 = "sha256-Pe6Ume7vH8WJG2EqOw31g3VYilfFsDBmNHtHcUXxqf0=";
  };

  buildInputs = [ python3 ];

  strictDeps = true;

  installPhase = ''
    install -Dm755 biblatex_check.py $out/bin/biblatex-check
  '';

  meta = with lib; {
    description = "Python2/3 script for checking BibLatex .bib files";
    homepage = "https://github.com/Pezmc/BibLatex-Check";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
