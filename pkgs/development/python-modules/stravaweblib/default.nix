{
  lib,
  arrow,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,
  stravalib,
  beautifulsoup4,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "stravaweblib";
  version = "0.0.8";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "pR0Ps";
    repo = "stravaweblib";
    rev = "refs/tags/v${version}";
    hash = "";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    stravalib
    beautifulsoup4
  ];

  pythonImportsCheck = [ "stravaweblib" ];

  meta = with lib; {
    description = "Python library for extending the Strava v3 API using web scraping";
    homepage = "https://github.com/pR0Ps/stravaweblib";
    license = licenses.mpl20;
    maintainers = with maintainers; [ stv0g ];
  };
}
