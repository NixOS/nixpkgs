{ lib, python3Packages, fetchFromGitHub }:

let
  pythonPackages = python3Packages;
in pythonPackages.buildPythonApplication rec {
  name = "asciinema-${version}";
  version = "1.3.0";

  buildInputs = with pythonPackages; [ nose ];
  propagatedBuildInputs = with pythonPackages; [ requests2 ];

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "asciinema";
    rev = "v${version}";
    sha256 = "1hx7xipyy9w72iwlawldlif9qk3f7b8jx8c1wcx114pqbjz5d347";
  };

  checkPhase = ''
    nosetests
  '';

  meta = {
    description = "Terminal session recorder and the best companion of asciinema.org";
    homepage = https://asciinema.org/;
    license = with lib.licenses; [ gpl3 ];
  };
}

