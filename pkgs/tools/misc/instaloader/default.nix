{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, sphinx
, requests
}:

buildPythonPackage rec {
  pname = "instaloader";
  version = "4.9.4";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "instaloader";
    repo = "instaloader";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-R26+ZvbUs4b5X1+wn6V7K7JqJsP31x7x5HVh+aPi8VU=";
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
