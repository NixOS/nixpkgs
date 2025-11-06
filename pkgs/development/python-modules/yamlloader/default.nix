{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
  pyyaml,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "yamlloader";
  version = "1.5.2";
  pyproject = true;

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

  meta = {
    description = "Case-insensitive list for Python";
    homepage = "https://github.com/Phynix/yamlloader";
    changelog = "https://github.com/Phynix/yamlloader/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ freezeboy ];
  };
}
