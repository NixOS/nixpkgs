{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, wheel
, black
, cloudpathlib
, confection
, isort
, mypy
, packaging
, pre-commit
, pydantic
, pytest
, requests
, ruff
, smart-open
, srsly
, typer
, types-requests
, types-setuptools
, wasabi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "weasel";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "weasel";
    rev = "refs/tags/v${version}";
    hash = "sha256-I8Omrez1wfAbCmr9hivqKN2fNgnFQRGm8OP7lb7YClk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    black
    cloudpathlib
    confection
    isort
    mypy
    packaging
    pre-commit
    pydantic
    pytest
    requests
    ruff
    smart-open
    srsly
    typer
    types-requests
    types-setuptools
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
