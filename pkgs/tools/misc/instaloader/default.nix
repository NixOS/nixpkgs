{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, sphinx
, requests
}:

buildPythonPackage rec {
  pname = "instaloader";
  version = "4.9.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "instaloader";
    repo = "instaloader";
    rev = "v${version}";
    sha256 = "sha256-IzOXtoHuKbeHlp4URAlRrSKZ8mRTK7QgsWGd5a99thY=";
  };

  propagatedBuildInputs = [
    requests
    sphinx
  ];

  pythonImportsCheck = [ "instaloader" ];

  meta = with lib; {
    homepage = "https://instaloader.github.io/";
    description = "Download pictures (or videos) along with their captions and other metadata from Instagram";
    maintainers = with maintainers; [ creator54 ];
    license = licenses.mit;
  };
}
