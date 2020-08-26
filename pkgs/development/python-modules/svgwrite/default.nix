{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pythonOlder
, pytest
}:

buildPythonPackage rec {
  pname = "svgwrite";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "svgwrite";
    rev = "v${version}";
    sha256 = "15xjz5b4dw1sg3a5k4wmzky4h5v1n937id8vl6hha1a2xj42z2s5";
  };

  # svgwrite requires Python 3.6 or newer
  disabled = pythonOlder "3.6";

  checkInputs = [
    pytest
  ];

  # embed_google_web_font test tried to pull font from internet
  checkPhase = ''
    pytest -k "not test_embed_google_web_font"
  '';

  meta = with lib; {
    description = "A Python library to create SVG drawings";
    homepage = "https://github.com/mozman/svgwrite";
    license = licenses.mit;
  };

}
