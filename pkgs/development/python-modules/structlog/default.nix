{
  lib,
  better-exceptions,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  greenlet,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  pretend,
  pytest-asyncio,
  pytestCheckHook,
  rich,
  simplejson,
  twisted,
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "25.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    tag = version;
    hash = "sha256-Ve6RBCQ8PJtlN/gzSjj/gxFkJsgcJhlNMAKDybBTx54=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    better-exceptions
    freezegun
    greenlet
    pretend
    pytest-asyncio
    pytestCheckHook
    rich
    simplejson
    twisted
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
