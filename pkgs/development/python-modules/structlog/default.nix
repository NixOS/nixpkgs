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
  version = "24.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    rev = "refs/tags/${version}";
    hash = "sha256-z3ecgsep/BQJ+Fv78rV4XiFU4+1aaUEfNEtIqy44KV4=";
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
    changelog = "https://github.com/hynek/structlog/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
