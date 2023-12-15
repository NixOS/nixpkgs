{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, wheel
, cloudpathlib
, confection
, packaging
, pydantic
, requests
, smart-open
, srsly
, typer
, wasabi
, pytestCheckHook
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

  nativeBuildInputs = [
    setuptools
    wheel
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
    description = "Weasel: A small and easy workflow system";
    homepage = "https://github.com/explosion/weasel/";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
