{
  lib,
  aiohttp,
  buildPythonPackage,
  colour,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ttls";
  version = "1.8.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jschlyter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1RctamOSnpZ+bcfwnCsj4OAR7KYzf0XQtSe7MTFMGy4=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    colour
    setuptools
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ttls" ];

  meta = with lib; {
    description = "Module to interact with Twinkly LEDs";
    mainProgram = "ttls";
    homepage = "https://github.com/jschlyter/ttls";
    changelog = "https://github.com/jschlyter/ttls/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
