{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "1.5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sigma67";
    repo = "ytmusicapi";
    rev = "refs/tags/${version}";
    hash = "sha256-3dJ9Mu1cblBJh3BVEyxdfO+RD8kSxpdvnvox7ljMWT4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
  ];

  doCheck = false; # requires network access

  pythonImportsCheck = [
    "ytmusicapi"
  ];

  meta = with lib; {
    description = "Python API for YouTube Music";
    homepage = "https://github.com/sigma67/ytmusicapi";
    changelog = "https://github.com/sigma67/ytmusicapi/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
