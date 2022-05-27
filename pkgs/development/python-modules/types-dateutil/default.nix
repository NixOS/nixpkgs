{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-python-dateutil";
  version = "2.8.17";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bFQmWiIWgd2H9h32dDvV6rBgzxtAhv9lwaj9dj7WNw4=";
  };

  pythonImportsCheck = [ "dateutil-stubs" ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ milibopp ];
  };
}
