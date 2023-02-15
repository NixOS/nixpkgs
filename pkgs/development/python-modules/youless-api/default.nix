{ lib
, buildPythonPackage
, fetchFromBitbucket
, pythonOlder
, certifi
, chardet
, idna
, nose
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "youless-api";
  version = "1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromBitbucket {
    owner = "jongsoftdev";
    repo = "youless-python-bridge";
    rev = version;
    hash = "sha256-yh4ZmMn5z6aTZrhj9ZmvpmsDOF4MeDcPtSgr4fimjGM=";
  };

  propagatedBuildInputs = [
    certifi
    chardet
    idna
    requests
    urllib3
  ];

  nativeCheckInputs = [
    nose
  ];

  pythonImportsCheck = [
    "youless_api"
  ];

  meta = with lib; {
    description = "Python library for YouLess sensors";
    homepage = "https://pypi.org/project/youless-api/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
