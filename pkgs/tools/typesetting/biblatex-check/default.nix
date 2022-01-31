{ lib, stdenv, fetchFromGitHub, fetchpatch, python3 }:

stdenv.mkDerivation rec {
  pname = "biblatex-check";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Pezmc";
    repo = "BibLatex-Check";
    rev = "v${version}";
    sha256 = "sha256-SNftPSwkG8mOddwHJCguyPPOjQ3/tBYFsEUbr0Z7cuk=";
  };

  buildInputs = [ python3 ];

  patches = [
    # Merged, but not in tagged release yet
    (fetchpatch {
      url = "https://github.com/Pezmc/BibLatex-Check/pull/55.patch";
      sha256 = "sha256-W2CpYAGrWVYALe55H7Q2GtGiN+6EGU2Y3wLldFo+BAY=";
    })
    # Submitted
    (fetchpatch {
      url = "https://github.com/Pezmc/BibLatex-Check/pull/56.patch";
      sha256 = "sha256-Xp/8HZHZMjgyl66GlLBNFslo8fVXgUE+VNvy2XHwQC8=";
    })
  ];

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
