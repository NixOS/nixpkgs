{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-dateutil";
  version = "2.8.19.5";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-python-dateutil";
    inherit version;
    hash = "sha256-q5H8X3FffXbZpQ09100MaN/jilTwI5z6BQZXWuTYep0=";
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
