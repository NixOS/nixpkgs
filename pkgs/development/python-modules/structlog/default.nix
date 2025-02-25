{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  pretend,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  simplejson,
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "25.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    tag = version;
    hash = "sha256-zhIiDy+Wnt03WDc4BwQpSfiZorDf8BHiORCw8TotgJU=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    freezegun
    pretend
    pytest-asyncio
    pytestCheckHook
    simplejson
  ];

  pythonImportsCheck = [ "structlog" ];

  meta = with lib; {
    description = "Painless structural logging";
    homepage = "https://github.com/hynek/structlog";
    changelog = "https://github.com/hynek/structlog/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
