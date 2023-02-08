{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2oToq+lcLhGtKyi6VXq45dyAhjvW+HOefBkWyVB1WvQ=";
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
