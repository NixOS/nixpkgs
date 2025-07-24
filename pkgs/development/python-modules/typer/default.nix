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
}:

buildPythonPackage rec {
  pname = "typer";
  version = "0.15.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "typer";
    tag = version;
    hash = "sha256-lZJKE8bxYxmDxAmnL7L/fL89gMe44voyHT20DUazd9E=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    click
    typing-extensions
    # Build includes the standard optional by default
    # https://github.com/tiangolo/typer/blob/0.12.3/pyproject.toml#L71-L72
  ]
  ++ optional-dependencies.standard;

  optional-dependencies = {
    standard = [
      rich
      shellingham
    ];
  };

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

  pythonImportsCheck = [ "typer" ];

  meta = {
    description = "Library for building CLI applications";
    homepage = "https://typer.tiangolo.com/";
    changelog = "https://github.com/tiangolo/typer/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ winpat ];
  };
}
