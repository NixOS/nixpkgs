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
  version = "5.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "tempora";
    tag = "v${version}";
    hash = "sha256-1Zeo8bUCHKPZ6I0HGT7bIh7IgbRL4j9Cv3t9FFiZ72s=";
  };

  postPatch = ''
    sed -i "/coherent\.licensed/d" pyproject.toml
  '';

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
    changelog = "https://github.com/jaraco/tempora/blob/${src.tag}/NEWS.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
