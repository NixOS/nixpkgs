{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jaraco-functools,
  pytest-freezer,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "tempora";
  version = "5.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "tempora";
    rev = "refs/tags/v${version}";
    hash = "sha256-M6nWKYvgn4tk2diiTDAYb1uQdP8H1M8yqhsFLJ9H7HU=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    jaraco-functools
    python-dateutil
  ];

  nativeCheckInputs = [
    pytest-freezer
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tempora"
    "tempora.schedule"
    "tempora.timing"
    "tempora.utc"
  ];

  meta = with lib; {
    description = "Objects and routines pertaining to date and time";
    mainProgram = "calc-prorate";
    homepage = "https://github.com/jaraco/tempora";
    changelog = "https://github.com/jaraco/tempora/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
