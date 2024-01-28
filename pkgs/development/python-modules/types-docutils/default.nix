{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-docutils";
  version = "0.20.0.20240125";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r3YOMR2Jrz+PtiVD6FCZ1v2dwDttGjva9mlXNnXVitg=";
  };

  nativeBuildInputs = [
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
