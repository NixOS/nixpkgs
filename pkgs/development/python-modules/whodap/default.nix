{ lib
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, httpx
}:

buildPythonPackage rec {
  pname = "whodap";
  version = "0.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Jm3+WMGuYc910TNDVzHjYcbNcts668D3xYORXxozWqA=";
  };

  propagatedBuildInputs = [
    httpx
  ];

  checkInputs = [
    asynctest
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_client.py"
  ];

  pythonImportsCheck = [
    "whodap"
  ];

  meta = with lib; {
    description = "Python RDAP utility for querying and parsing information about domain names";
    homepage = "https://github.com/pogzyb/whodap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
