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
  version = "4.14.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "instaloader";
    repo = "instaloader";
    tag = "v${version}";
    sha256 = "sha256-ZGCO5xNUwrQFsSaAiP1yffrkSN+Mxdtrw+Kve0s2t2E=";
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
