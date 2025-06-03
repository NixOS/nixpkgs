{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cloudpathlib,
  confection,
  packaging,
  pydantic,
  requests,
  smart-open,
  srsly,
  typer,
  wasabi,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "weasel";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "weasel";
    tag = "v${version}";
    hash = "sha256-gXPHEoEY0qKcpAtqHlUw5c43/6hKseCx+vBNzEXFF2A=";
  };

  pythonRelaxDeps = [
    "cloudpathlib"
    "smart-open"
    "typer"
  ];

  build-system = [ setuptools ];

  dependencies = [
    cloudpathlib
    confection
    packaging
    pydantic
    requests
    smart-open
    srsly
    typer
    wasabi
  ];

  pythonImportsCheck = [ "weasel" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # This test requires internet access
    "test_project_assets"
    "test_project_git_dir_asset"
    "test_project_git_file_asset"
  ];

  meta = {
    description = "Small and easy workflow system";
    homepage = "https://github.com/explosion/weasel/";
    changelog = "https://github.com/explosion/weasel/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "weasel";
  };
}
