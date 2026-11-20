{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  requests,
  responses,
  setuptools_80,
  urllib3,
}:

buildPythonPackage rec {
  pname = "tank-utility";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "krismolendyke";
    repo = "tank-utility";
    tag = version;
    hash = "sha256-koLdumixS11J1Ia9aCihQU7XXu0dziNzMkqEQ2LH9o4=";
  };

  build-system = [ setuptools_80 ];

  dependencies = [
    requests
    urllib3
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "tank_utility" ];

  meta = {
    description = "Library for the Tank Utility API";
    mainProgram = "tank-utility";
    homepage = "https://github.com/krismolendyke/tank-utility";
    changelog = "https://github.com/krismolendyke/tank-utility/blob/${version}/HISTORY.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
