{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-decorator";
  version = "5.1.8.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Sddr47Ry/U+k3DO6VapLke5h6/c3nRrSVfxWMvy9wAc=";
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
