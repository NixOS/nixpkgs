{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-docutils";
  version = "0.19.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ozSnA6hoiRDQhpRk8fb4vTMNdYQ72rT4k1R7+ylBegE=";
  };

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
