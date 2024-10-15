{
  lib,
  buildPythonPackage,
  cloudpathlib,
  confection,
  fetchFromGitHub,
  packaging,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  smart-open,
  srsly,
  typer,
  wasabi,
}:

buildPythonPackage rec {
  pname = "weasel";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "weasel";
    rev = "refs/tags/v${version}";
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

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # This test requires internet access
    "test_project_assets"
    "test_project_git_dir_asset"
    "test_project_git_file_asset"
  ];

  meta = with lib; {
    description = "Small and easy workflow system";
    homepage = "https://github.com/explosion/weasel/";
    changelog = "https://github.com/explosion/weasel/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
    mainProgram = "weasel";
  };
}
