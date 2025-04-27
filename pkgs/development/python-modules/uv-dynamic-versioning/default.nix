{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  dunamai,
  eval-type-backport,
  jinja2,
  pydantic,
  returns,
  tomlkit,

  # tests
  gitpython,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  gitSetupHook,
  gitMinimal,
}:

buildPythonPackage rec {
  pname = "uv-dynamic-versioning";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ninoseki";
    repo = "uv-dynamic-versioning";
    tag = "v${version}";
    # Tests perform mock operations on the local repo
    leaveDotGit = true;
    hash = "sha256-iIWghJXhs0IblO7Kgfe6lEc0F/KYF1c8/TN5tkIvXa0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    dunamai
    eval-type-backport
    hatchling
    jinja2
    pydantic
    returns
    tomlkit
  ];

  pythonImportsCheck = [
    "uv_dynamic_versioning"
  ];

  nativeCheckInputs = [
    gitpython
    pytestCheckHook
    writableTmpDirAsHomeHook
    gitSetupHook
    gitMinimal
  ];

  meta = {
    description = "Dynamic versioning based on VCS tags for uv/hatch project";
    homepage = "https://github.com/ninoseki/uv-dynamic-versioning";
    changelog = "https://github.com/ninoseki/uv-dynamic-versioning/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
