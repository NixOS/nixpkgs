{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "svgwrite";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "svgwrite";
    rev = "v${version}";
    sha256 = "sha256-uOsrDhE9AwWU7GIrCVuL3uXTPqtrh8sofvo2C5t+25I=";
  };

  # svgwrite requires Python 3.6 or newer
  disabled = pythonOlder "3.6";

  checkInputs = [ pytestCheckHook ];

  disabledTests = [
    # embed_google_web_font test tried to pull font from internet
    "test_embed_google_web_font"
  ];

  meta = with lib; {
    description = "A Python library to create SVG drawings";
    homepage = "https://github.com/mozman/svgwrite";
    license = licenses.mit;
  };

}
