{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pytest-asyncio
, pretend
, freezegun
, hatch-fancy-pypi-readme
, hatch-vcs
, hatchling
, simplejson
, typing-extensions
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "structlog";
  version = "22.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "structlog";
    rev = "refs/tags/${version}";
    sha256 = "sha256-+r+M+uTXdNBWQf0TGQuZgsCXg2CBKwH8ZE2+uAe0Dzg=";
  };

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  pythonImportsCheck = [
    "structlog"
  ];

  nativeCheckInputs = [
    freezegun
    pretend
    pytest-asyncio
    pytestCheckHook
    simplejson
  ];

  meta = with lib; {
    description = "Painless structural logging";
    homepage = "https://github.com/hynek/structlog";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
