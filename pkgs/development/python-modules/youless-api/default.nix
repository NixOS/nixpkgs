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
  version = "0.12";

  disabled = pythonOlder "3.7";

  src = fetchFromBitbucket {
    owner = "jongsoftdev";
    repo = "youless-python-bridge";
    rev = version;
    sha256 = "18hymahpblq87i7lv479sizj8mgxawjhj31g4j1lyna1mds3887k";
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
