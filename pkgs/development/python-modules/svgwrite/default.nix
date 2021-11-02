{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, pythonOlder
, pytest
}:

buildPythonPackage rec {
  pname = "svgwrite";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "mozman";
    repo = "svgwrite";
    rev = "v${version}";
    sha256 = "sha256-d//ZUFb5yj51uD1fb6yJJROaQ2MLyfA3Pa84TblqLNk=";
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
