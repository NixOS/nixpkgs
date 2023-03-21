{ lib
, buildPythonPackage
, fetchPypi
, types-urllib3
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.28.11.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/I6qCcwBRpnGtjxgwuOt0MiwmkEMgYtaxuZfkqJt3gk=";
  };

  propagatedBuildInputs = [
    types-urllib3
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "requests-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for requests";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
