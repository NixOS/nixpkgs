{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

python3Packages.buildPythonApplication rec {
  pname = "asciinema";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
    rev = "v${version}";
    sha256 = "1alcz018jrrpasrmgs8nw775a6pf62xq2xgs54c4mb396prdqy4x";
  };

  checkInputs = [ glibcLocales python3Packages.nose ];

  checkPhase = ''
    LC_ALL=en_US.UTF-8 nosetests
  '';

  meta = {
    description = "Terminal session recorder and the best companion of asciinema.org";
    homepage = "https://asciinema.org/";
    license = with lib.licenses; [ gpl3 ];
  };
}

