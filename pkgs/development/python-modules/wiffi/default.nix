{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wiffi";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mampfes";
    repo = "python-wiffi";
    rev = version;
    sha256 = "sha256-uB4M3etW1DCE//V2pcmsLZbORmrL00pbPADMQD5y3CY=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "wiffi"
  ];

  meta = with lib; {
    description = "Python module to interface with STALL WIFFI devices";
    homepage = "https://github.com/mampfes/python-wiffi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
