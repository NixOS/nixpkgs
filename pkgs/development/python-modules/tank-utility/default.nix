{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "tank-utility";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "krismolendyke";
    repo = "tank-utility";
    tag = version;
    hash = "sha256-h9y3X+FSzSFt+bd/chz+x0nocHaKZ8DvreMxAYMs8/E=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
