{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "57.4.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QVocIxAaBdoX62a+1dWoZXAuWmn3TGbb8a9kPc6Ukqs=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "setuptools-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
