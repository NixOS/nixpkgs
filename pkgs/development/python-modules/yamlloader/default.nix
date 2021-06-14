{ lib, buildPythonPackage, fetchPypi
, pytest, pyyaml, hypothesis
}:

buildPythonPackage rec {
  pname = "yamlloader";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e96dc3dc6895d814c330c054c966d993fc81ef1dbf5a30a4bdafeb256359e058";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  checkInputs = [
    hypothesis
    pytest
  ];

  pythonImportsCheck = [
    "yaml"
    "yamlloader"
  ];

  meta = with lib; {
    description = "A case-insensitive list for Python";
    homepage = "https://github.com/Phynix/yamlloader";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
