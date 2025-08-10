{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
  pyyaml,
  hypothesis,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "yamlloader";
  version = "1.5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wQrBMhpiaxyosJ0/Ov6YVbgYORxZmSp2tl5KLZXqxBs=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [ pyyaml ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "yaml"
    "yamlloader"
  ];

  meta = with lib; {
    description = "Case-insensitive list for Python";
    homepage = "https://github.com/Phynix/yamlloader";
    changelog = "https://github.com/Phynix/yamlloader/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
