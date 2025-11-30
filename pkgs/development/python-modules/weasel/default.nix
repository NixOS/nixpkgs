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
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "weasel";
    tag = "release-v${version}";
    hash = "sha256-Xd7cJlUi/a8gwtnuO9wqZiHT1xVMbp6V6Ha+Kyr4tFE=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace setup.cfg requirements.txt \
      --replace "typer-slim" "typer"
  '';

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
    # These tests require internet access
    "test_project_assets"
    "test_project_git_dir_asset"
    "test_project_git_file_asset"
  ];

  meta = {
    description = "Small and easy workflow system";
    homepage = "https://github.com/explosion/weasel/";
    changelog = "https://github.com/explosion/weasel/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "weasel";
  };
}
