{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "somweb";
  version = "1.3.3b7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "taarskog";
    repo = "pySOMweb";
    rev = "v${version}";
    hash = "sha256-jdqVf+XauGSr6cTVcQUZt/zNa9LWi71FlmuvFic9790=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
  ];

  pythonImportsCheck = [ "somweb" ];

  doCheck = false; # no tests

  meta = with lib; {
    changelog = "https://github.com/taarskog/pySOMweb/releases/tag/v${version}";
    description = "Client library to control garage door operators produced by SOMMER through their SOMweb device";
    homepage = "https://github.com/taarskog/pysomweb";
    license = licenses.mit;
    maintainers = with maintainers; [ uvnikita ];
    mainProgram = "somweb";
  };
}
