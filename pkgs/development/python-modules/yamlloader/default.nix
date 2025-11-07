{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "Phynix";
    repo = "yamlloader";
    tag = version;
    hash = "sha256-SNb1iXao+TNW872qDtEldZj6S+yJxRlsnw6ye92RFSk=";
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

  disabledTestPaths = [
    # TypeError: cannot pickle '_thread.RLock' object
    # https://github.com/Phynix/yamlloader/issues/64
    "tests/test_ordereddict.py"
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
    maintainers = with lib.maintainers; [
      freezeboy
      sarahec
    ];
  };
}
