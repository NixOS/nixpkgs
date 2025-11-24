{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pbr,
  setuptools,
  twine,

  # dependencies
  click,
  click-completion,
  inquirer,
  notify-py,
  pendulum,
  prettytable,
  requests,
  validate-email,

  # tests
  factory-boy,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "toggl-cli";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AuHau";
    repo = "toggl-cli";
    tag = "v${version}";
    hash = "sha256-f3s0XlhQZH9xC5xyM+e2VG9j1GK0qqWFm4Xy08Iwj/Q=";
  };

  env.PBR_VERSION = version;

  build-system = [
    pbr
    setuptools
    twine
  ];

  pythonRelaxDeps = true;

  dependencies = [
    click
    click-completion
    inquirer
    notify-py
    pbr
    pendulum
    prettytable
    requests
    setuptools
    validate-email
  ];

  nativeCheckInputs = [
    factory-boy
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/toggl";
  versionCheckProgramArg = "--version";

  disabledTests = [
    "integration"
    "premium"
    "test_now"
    "test_parsing"
    "test_type_check"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted: '/etc/localtime'
    "tests/unit/cli/test_types.py"
  ];

  pythonImportsCheck = [ "toggl" ];

  meta = {
    description = "Command line tool and set of Python wrapper classes for interacting with toggl's API";
    homepage = "https://toggl.uhlir.dev/";
    changelog = "https://github.com/AuHau/toggl-cli/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mmahut ];
    mainProgram = "toggl";
  };
}
