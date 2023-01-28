{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pyyaml
, hypothesis
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yamlloader";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NWaf17n4xrONuGGlFwFULEJnK0boq2MlNIaoy4N3toc=";
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  nativeCheckInputs = [
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
