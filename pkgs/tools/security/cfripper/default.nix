{
  lib,
  fetchFromGitHub,
  python3,
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      pydantic = self.pydantic_1;
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "cfripper";
  version = "1.15.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Skyscanner";
    repo = "cfripper";
    rev = "refs/tags/v${version}";
    hash = "sha256-h/NNTE5u1coyD4owiGjsK6SIuvDq1SQOPW4RM4yJtno=";
  };

  pythonRelaxDeps = [
    "pluggy"
  ];

  nativeBuildInputs = with python.pkgs; [
    pythonRelaxDepsHook
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = with python.pkgs; [
    boto3
    cfn-flip
    click
    pluggy
    pycfmodel
    pydash
    pyyaml
    setuptools
  ];

  nativeCheckInputs = with python.pkgs; [
    moto
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Tests are failing
    "tests/test_boto3_client.py"
    "tests/config/test_pluggy.py"
  ];

  disabledTests = [
    # Assertion fails
    "test_multiple_resources_with_wildcard_resources_are_detected"
  ];

  pythonImportsCheck = [
    "cfripper"
  ];

  meta = with lib; {
    description = "Tool for analysing CloudFormation templates";
    mainProgram = "cfripper";
    homepage = "https://github.com/Skyscanner/cfripper";
    changelog = "https://github.com/Skyscanner/cfripper/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
