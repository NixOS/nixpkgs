{ lib
, buildPythonPackage
, cloudpathlib
, confection
, fetchFromGitHub
, packaging
, pydantic
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, requests
, setuptools
, smart-open
, srsly
, typer
, wasabi
}:

buildPythonPackage rec {
  pname = "weasel";
  version = "0.3.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "weasel";
    rev = "refs/tags/v${version}";
    hash = "sha256-6Ck8R10/YW2Nc6acNk2bzgyqSg+OPqwyJjhUgXP/umw=";
  };

  pythonRelaxDeps = [
    "cloudpathlib"
    "smart-open"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
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
  ];

  meta = with lib; {
    description = "A small and easy workflow system";
    mainProgram = "weasel";
    homepage = "https://github.com/explosion/weasel/";
    changelog = "https://github.com/explosion/weasel/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
