{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, requests
}:

buildPythonPackage rec {
  pname = "serverfiles";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "biolab";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-MjEqCPoHDd86vNlFMjdsSQ4+lZIJ9l4PjCkTUUkslJ0=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ requests ];

  doCheck = true;

  pythonImportsCheck = [ "serverfiles" ];

  meta = with lib; {
    description = "A utility that accesses files on a HTTP server and stores them locally for reuse";
    homepage = "https://orangedatamining.com/";
    changelog = "https://github.com/biolab/serverfiles/releases/refs/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ totoroot ];
  };
}
