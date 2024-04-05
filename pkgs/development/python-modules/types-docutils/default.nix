{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-docutils";
  version = "0.20.0.20240331";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rJnN80BAyYIIH1QjfWAX+PXa/gvruBilmL+Xpl9bFxU=";
  };

  build-system = [
    setuptools
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "docutils-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for docutils";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
