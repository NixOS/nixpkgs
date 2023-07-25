{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, sphinx
, requests
}:

buildPythonPackage rec {
  pname = "instaloader";
  version = "4.9.6";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "instaloader";
    repo = "instaloader";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ZxvJPDj+r7KSyXpYNQIgnda5OS77GOFM901ZHgR6c4k=";
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
