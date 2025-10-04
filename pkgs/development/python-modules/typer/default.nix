{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  click,
  typing-extensions,

  # optional-dependencies
  rich,
  shellingham,

  # tests
  coverage,
  pytest-xdist,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  procps,

  # typer or typer-slim
  package ? "typer",
}:

buildPythonPackage rec {
  pname = package;
  version = "0.17.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "typer";
    tag = version;
    hash = "sha256-gd4GgoRnQVVmwmW5DprmNRxgjFiRRa8HB6xO9U9wHI8=";
  };

  env.TIANGOLO_BUILD_PACKAGE = package;

  build-system = [ pdm-backend ];

  dependencies = [
    click
    typing-extensions
  ]
  # typer includes the standard optional by default
  # https://github.com/tiangolo/typer/blob/0.12.3/pyproject.toml#L71-L72
  ++ lib.optionals (package == "typer") optional-dependencies.standard;

  optional-dependencies = {
    standard = [
      rich
      shellingham
    ];
  };

  doCheck = package == "typer"; # tests expect standard dependencies

  nativeCheckInputs = [
    coverage # execs coverage in tests
    pytest-xdist
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    procps
  ];

  disabledTests = [
    "test_scripts"
    # Likely related to https://github.com/sarugaku/shellingham/issues/35
    # fails also on Linux
    "test_show_completion"
    "test_install_completion"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    "test_install_completion"
  ];

  disabledTestPaths = [
    # likely click 8.2 compat issue
    "tests/test_tutorial/test_parameter_types/test_bool/test_tutorial002_an.py"
    "tests/test_tutorial/test_parameter_types/test_bool/test_tutorial002.py"
  ];

  pythonImportsCheck = [ "typer" ];

  meta = {
    description = "Library for building CLI applications";
    homepage = "https://typer.tiangolo.com/";
    changelog = "https://github.com/tiangolo/typer/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ winpat ];
  };
}
