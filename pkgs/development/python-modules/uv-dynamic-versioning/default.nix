{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  dunamai,
  eval-type-backport,
  pydantic,
  returns,
  tomlkit,

  # tests
  gitpython,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "uv-dynamic-versioning";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ninoseki";
    repo = "uv-dynamic-versioning";
    tag = "v${version}";
    # Tests perform mock operations on the local repo
    leaveDotGit = true;
    hash = "sha256-rcvNQ6QrVu2pp1aWTalNK2R7CW/NfFGmu4Dea1EN2ZA=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    dunamai
    eval-type-backport
    hatchling
    pydantic
    returns
    tomlkit
  ];

  pythonImportsCheck = [
    "uv_dynamic_versioning"
  ];

  preCheck = ''
    git config --global user.email "nobody@example.com"
    git config --global user.name "Nobody"
  '';

  nativeCheckInputs = [
    gitpython
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Dynamic versioning based on VCS tags for uv/hatch project";
    homepage = "https://github.com/ninoseki/uv-dynamic-versioning";
    changelog = "https://github.com/ninoseki/uv-dynamic-versioning/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
