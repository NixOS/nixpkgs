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
  version = "1.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fb2YQh2AkMUhZV8bBsoDAGfynfUlOoh4EmvOOpD1aBc=";
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
    changelog = "https://github.com/Phynix/yamlloader/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
