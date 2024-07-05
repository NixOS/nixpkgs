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
  twisted,
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "24.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    rev = "refs/tags/${version}";
    hash = "sha256-0Yc28UEeozK2+IqILFTqHoTiM5L2SA4t6jld4qTBSzQ=";
  };

  nativeBuildInputs = [
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
    twisted
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
