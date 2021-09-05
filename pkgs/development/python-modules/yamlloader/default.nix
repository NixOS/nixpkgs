{ lib, buildPythonPackage, fetchPypi
, pytest, pyyaml, hypothesis
}:

buildPythonPackage rec {
  pname = "yamlloader";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a297c7a197683ba02e5e2b882ffd6c6180d01bdefb534b69cd3962df020bfe6";
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
