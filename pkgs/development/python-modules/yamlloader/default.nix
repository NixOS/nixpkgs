{ lib, buildPythonPackage, fetchPypi
, pytest, pyyaml
}:

buildPythonPackage rec {
  pname = "yamlloader";
  version = "0.5.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3KtfFrObsD0Q3aTNTzDJQ2dexMd3GAf8Z+fxuzGb9Mg=";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  checkInputs = [
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
