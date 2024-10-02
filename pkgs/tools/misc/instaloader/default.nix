{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, sphinx
, requests
}:

buildPythonPackage rec {
  pname = "instaloader";
  version = "4.13.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "instaloader";
    repo = "instaloader";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-eu2Hp3uomtPuMNjJGprcqK5HApKEjtXU9IQ5yT55cic=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
    mainProgram = "instaloader";
  };
}
