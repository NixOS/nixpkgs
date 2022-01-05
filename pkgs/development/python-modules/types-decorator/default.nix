{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-decorator";
  version = "5.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3dd9027af1131b4e55ccd09248b7accc7a02d567139e2009ed20db13cf90600";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "decorator-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for decorator";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
