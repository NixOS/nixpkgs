{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-docutils";
  version = "0.20.0.20240317";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I2V6qw3lhjTREZFLZ3sYVYZ/Fs2anqEQJU4jtIZT4ag=";
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
