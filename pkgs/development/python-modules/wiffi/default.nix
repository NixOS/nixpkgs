{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "wiffi";
  version = "1.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mampfes";
    repo = "python-wiffi";
    rev = "refs/tags/${version}";
    hash = "sha256-pnbzJxq8K947Yg54LysPPho6IRKf0cc+szTETgyzFao=";
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
    changelog = "https://github.com/mampfes/python-wiffi/blob/${version}/HISTORY.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
