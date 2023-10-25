{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "volkszaehler";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-volkszaehler";
    rev = "refs/tags/${version}";
    hash = "sha256-jX0nwBsBYU383LG8f08FVI7Lo9gnyPSQ0fiEF8dQc/M=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [
    "volkszaehler"
  ];

  meta = with lib; {
    description = "Python module for interacting with the Volkszahler API";
    homepage = "https://github.com/home-assistant-ecosystem/python-volkszaehler";
    changelog = "https://github.com/home-assistant-ecosystem/python-volkszaehler/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
