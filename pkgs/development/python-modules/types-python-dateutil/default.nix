{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-python-dateutil";
  version = "2.8.19.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Sm9MwZzkuhoIZwhx4pe/OAL1XU8SnmqiRD9UC2z4A9I=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "dateutil-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
