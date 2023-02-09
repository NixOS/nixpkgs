{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-dateutil";
  version = "2.8.19.6";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-python-dateutil";
    inherit version;
    hash = "sha256-Sm9MwZzkuhoIZwhx4pe/OAL1XU8SnmqiRD9UC2z4A9I=";
  };

  pythonImportsCheck = [
    "dateutil-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ milibopp ];
  };
}
