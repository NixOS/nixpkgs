{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, pretend
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, simplejson
, twisted
, typing-extensions
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "23.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    rev = "refs/tags/${version}";
    hash = "sha256-KSHKgkv+kObKCdWZDg5o6QYe0AMND9VLdEuseY/GyDY=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    freezegun
    pretend
    pytest-asyncio
    pytestCheckHook
    simplejson
    twisted
  ];

  disabledTests = [
    # _pickle.PicklingError: Only BytesLoggers to sys.stdout and sys.stderr can be pickled.
    "test_pickle"
  ];

  pythonImportsCheck = [
    "structlog"
  ];

  meta = with lib; {
    description = "Painless structural logging";
    homepage = "https://github.com/hynek/structlog";
    changelog = "https://github.com/hynek/structlog/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
