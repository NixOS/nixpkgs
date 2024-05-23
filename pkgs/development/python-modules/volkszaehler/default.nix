{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "volkszaehler";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-volkszaehler";
    rev = "refs/tags/${version}";
    hash = "sha256-7SB0x0BO9SMeMG1M/hH4fX7oDbtwPgCzyRrrUq1/WPo=";
  };

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [ "volkszaehler" ];

  meta = with lib; {
    description = "Python module for interacting with the Volkszahler API";
    homepage = "https://github.com/home-assistant-ecosystem/python-volkszaehler";
    changelog = "https://github.com/home-assistant-ecosystem/python-volkszaehler/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
