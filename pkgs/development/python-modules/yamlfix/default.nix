{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  maison,
  pdm-backend,
  pytest-freezegun,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  ruyaml,
  setuptools,
  writableTmpDirAsHomeHook,
}:
let
  maison142 = maison.overridePythonAttrs (old: rec {
    version = "1.4.2";
    src = fetchFromGitHub {
      owner = "dbatten5";
      repo = "maison";
      tag = "v${version}";
      hash = "sha256-XNo7QS8BCYzkDozLW0T+KMQPI667lDTCFtOqKq9q3hw=";
    };
    disabledTestPaths = [
      # ValidationError
      "tests/unit/test_config.py::TestValidation::test_use_schema_values"
      "tests/unit/test_config.py::TestValidation::test_not_use_schema_values"
    ];
  });
in

buildPythonPackage rec {
  pname = "yamlfix";
  version = "1.16.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lyz-code";
    repo = "yamlfix";
    tag = version;
    hash = "sha256-RRpU6cxb3a3g6RrJbUCxY7YC87HHbGkhOFtE3hf8HdA=";
  };

  build-system = [
    setuptools
    pdm-backend
  ];

  dependencies = [
    click
    maison142
    ruyaml
  ];

  nativeCheckInputs = [
    pytest-freezegun
    pytest-xdist
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "yamlfix" ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # AssertionError
    "tests/e2e/test_cli.py"
  ];

  meta = {
    description = "Python YAML formatter that keeps your comments";
    homepage = "https://github.com/lyz-code/yamlfix";
    changelog = "https://github.com/lyz-code/yamlfix/blob/${version}/CHANGELOG.md";
    mainProgram = "yamlfix";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ koozz ];
  };
}
