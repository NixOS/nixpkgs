{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-python-dateutil";
  version = "2.8.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7zBTt0XwHERDtRK2s9WwT7ry1HaqUDtsyTIEah7fpWo=";
  };

  pythonImportsCheck = [ "dateutil-stubs" ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ milibopp ];
  };
}
