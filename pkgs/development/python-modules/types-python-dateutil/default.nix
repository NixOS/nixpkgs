{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-python-dateutil";
  version = "2.8.19.20240311";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UReCJ7vUy+w13Jrf+/Wdgy8g4JhC19y4xzsWm4eAt8s=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "dateutil-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
