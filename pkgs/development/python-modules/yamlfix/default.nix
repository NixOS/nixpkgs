{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,
  setuptools,

  # dependencies
  click,
  maison,
  pydantic,
  ruyaml,

  # tests
  pytest-freezegun,
  pytest-xdist,
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "yamlfix";
  version = "1.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lyz-code";
    repo = "yamlfix";
    tag = version;
    hash = "sha256-+bD/kKOI19zptPhO6vB2Q0bQWjkBr+vgqBgAyaoSLJc=";
  };

  build-system = [
    pdm-backend
    setuptools
  ];

  dependencies = [
    click
    maison
    pydantic
    ruyaml
  ];

  nativeCheckInputs = [
    pytest-freezegun
    pytest-xdist
    pytestCheckHook
    writableTmpDirAsHomeHook
    versionCheckHook
  ];

  pythonImportsCheck = [ "yamlfix" ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
    "-Wignore::ResourceWarning"
  ];

  disabledTestPaths = [
    # Broken since click was updated to 8.2.1 in https://github.com/NixOS/nixpkgs/pull/448189
    # TypeError: CliRunner.__init__() got an unexpected keyword argument 'mix_stderr'
    "tests/e2e/test_cli.py"
  ];

  disabledTests = [
    # AssertionError
    "test_if_line_length"
    "test_anchors_and_aliases_with_duplicate_merge_keys"
    "test_fix_code_respects"
  ];

  meta = {
    description = "Python YAML formatter that keeps your comments";
    homepage = "https://github.com/lyz-code/yamlfix";
    changelog = "https://github.com/lyz-code/yamlfix/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ koozz ];
    mainProgram = "yamlfix";
  };
}
