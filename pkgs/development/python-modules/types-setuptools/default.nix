{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "69.1.0.20240308";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rU9eUSUe7cvkqo2whEr2ZUBUqvycD20/H6APcHPBd2c=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "setuptools-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
