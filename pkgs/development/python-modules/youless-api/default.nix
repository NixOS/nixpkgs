{ lib
, buildPythonPackage
, fetchFromBitbucket
, pythonOlder
, certifi
, chardet
, idna
, nose
, requests
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "youless-api";
  version = "0.14";

  disabled = pythonOlder "3.7";

  src = fetchFromBitbucket {
    owner = "jongsoftdev";
    repo = "youless-python-bridge";
    rev = version;
    sha256 = "sha256-ZHDQ+4Urv0ZxKFASsgDG12mpfRiCN2DwU6Rgc9ye5qY=";
  };

  propagatedBuildInputs = [
    certifi
    chardet
    idna
    requests
    six
    urllib3
  ];

  checkInputs = [
    nose
  ];

  pythonImportsCheck = [ "youless_api" ];

  meta = with lib; {
    description = "Python library for YouLess sensors";
    homepage = "https://pypi.org/project/youless-api/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
