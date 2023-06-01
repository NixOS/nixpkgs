{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-ujson";
  version = "5.7.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f/Kmd2BI5q1qvH6+39Qq4bbABVEq/7rkTK8/selrXRI=";
  };

  doCheck = false;

  pythonImportsCheck = [
    "ujson-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for ujson";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ centromere ];
  };
}
