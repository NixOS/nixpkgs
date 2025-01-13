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
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AuHau";
    repo = "toggl-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-RYOnlZxg3TZQO5JpmWlnUdL2hNFu4bjkdGU4c2ysqpA=";
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
  versionCheckProgramArg = [ "--version" ];

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
    changelog = "https://github.com/AuHau/toggl-cli/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mmahut ];
    mainProgram = "toggl";
  };
}
