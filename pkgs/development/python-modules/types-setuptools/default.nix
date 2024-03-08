{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "69.1.0.20240223";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iohqH9BrZoeC372t7U/YpOjJ89jUwCrN0SQN8Jj1C/c=";
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
