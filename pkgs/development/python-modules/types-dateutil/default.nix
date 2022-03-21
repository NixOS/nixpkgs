{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-python-dateutil";
  version = "2.8.10";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-a886rnJC5Xk7r9eyvPtOJV63srMUSs0N8OGC3OWMytM=";
  };

  pythonImportsCheck = [ "dateutil-stubs" ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ milibopp ];
  };
}
