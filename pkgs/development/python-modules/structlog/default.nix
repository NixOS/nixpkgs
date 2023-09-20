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
, pythonAtLeast
, pythonOlder
, simplejson
, typing-extensions
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "23.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    rev = "refs/tags/${version}";
    hash = "sha256-0zHvBMiZB4cGntdYXA7C9V9+FfnDB6sHGuFRYAo/LJw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
