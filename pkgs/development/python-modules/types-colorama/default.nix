{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FXy+ZuFjllliWEZNONeMrojYEus9erKoc+Da9PR8bIk=";
  };

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for colorama";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
