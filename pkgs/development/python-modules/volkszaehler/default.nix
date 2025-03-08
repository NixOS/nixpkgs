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
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-volkszaehler";
    tag = version;
    hash = "sha256-2XOV+Cft7xLIDNDpwNc+F8VasCYD8XEkxnwW0iS/p9U=";
  };

  build-system = [ setuptools ];

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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
