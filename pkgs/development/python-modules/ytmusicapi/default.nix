{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ytmusicapi";
  version = "1.7.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sigma67";
    repo = "ytmusicapi";
    rev = "refs/tags/${version}";
    hash = "sha256-mFjNtZdLpS1jfqF/KZ1p8H0pWUGsIdFDxhc4dZnv6HM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ requests ];

  doCheck = false; # requires network access

  pythonImportsCheck = [ "ytmusicapi" ];

  meta = with lib; {
    description = "Python API for YouTube Music";
    homepage = "https://github.com/sigma67/ytmusicapi";
    changelog = "https://github.com/sigma67/ytmusicapi/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "ytmusicapi";
  };
}
