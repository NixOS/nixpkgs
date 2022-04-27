{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-python-dateutil";
  version = "2.8.14";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Nnwf+hpSpLKlNMmzC0CwHyt/LqR6l/2CH2x20ceuMSk=";
  };

  pythonImportsCheck = [ "dateutil-stubs" ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ milibopp ];
  };
}
