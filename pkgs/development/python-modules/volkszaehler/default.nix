{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "volkszaehler";
  version = "0.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-volkszaehler";
    rev = version;
    sha256 = "sha256-EiruMlhXvbUhCaDtHc3qCLbpp/KHp9rVpk2FmbR4A/k=";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
