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
<<<<<<< HEAD
  version = "1.19.1";
=======
  version = "1.19.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lyz-code";
    repo = "yamlfix";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-+bD/kKOI19zptPhO6vB2Q0bQWjkBr+vgqBgAyaoSLJc=";
=======
    hash = "sha256-c8vspcouS3r0S/4S210QGYT2XdU3aR0FvUoKaC2WLUM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

  meta = {
    description = "Python YAML formatter that keeps your comments";
    homepage = "https://github.com/lyz-code/yamlfix";
    changelog = "https://github.com/lyz-code/yamlfix/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ koozz ];
    mainProgram = "yamlfix";
  };
}
