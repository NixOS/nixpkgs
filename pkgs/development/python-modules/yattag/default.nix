{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.15.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lg+lS+EinZb0MXgTPgsZXAAzkf3Ens22tptzdNtr5BY=";
  };

  pythonImportsCheck = [
    "yattag"
  ];

  meta = with lib; {
    description = "Library to generate HTML or XML";
    homepage = "https://www.yattag.org/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ];
  };
}
