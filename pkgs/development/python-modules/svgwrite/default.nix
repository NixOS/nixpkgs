{ lib
, buildPythonPackage
, fetchFromGitHub
, pyparsing
, pytest
}:

buildPythonPackage rec {
  pname = "svgwrite";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "svgwrite";
    rev = "v${version}";
    sha256 = "14wz0y118a5wwfzin6cirr9254p4y825lnrnackihdbpw22gcw11";
  };

  propagatedBuildInputs = [
    pyparsing
  ];

  checkInputs = [
    pytest
  ];

  # embed_google_web_font test tried to pull font from internet
  checkPhase = ''
    pytest -k "not test_embed_google_web_font"
  '';

  meta = with lib; {
    description = "A Python library to create SVG drawings";
    homepage = https://github.com/mozman/svgwrite;
    license = licenses.mit;
  };

}
