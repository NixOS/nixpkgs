{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "volkszaehler";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eIHL4o6PxSHRnhdT8XV2YsV57B2c6xQSuOKm0VXrb0M=";
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
