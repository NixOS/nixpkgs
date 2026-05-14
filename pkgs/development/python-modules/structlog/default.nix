{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  time-machine,
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "25.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    tag = version;
    hash = "sha256-dY18eZ7IEzP/eKR7d2CjpTRr2KfXy+YmeZMueHkLSQY=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    time-machine
  ];

  pythonImportsCheck = [ "structlog" ];

  meta = {
    description = "Painless structural logging";
    homepage = "https://github.com/hynek/structlog";
    changelog = "https://github.com/hynek/structlog/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
