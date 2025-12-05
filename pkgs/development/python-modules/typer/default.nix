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
  pytest-xdist,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  procps,

  # typer or typer-slim
  package ? "typer",
}:

buildPythonPackage rec {
  pname = package;
  version = "0.19.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "typer";
    tag = version;
    hash = "sha256-mMsOEI4FpLkLkpjxjnUdmKdWD65Zx3Z1+L+XsS79k44=";
  };

  postPatch = ''
    for f in $(find tests -type f -print); do
      # replace `sys.executable -m coverage run` with `sys.executable`
      sed -z -i 's/"-m",\n\?\s*"coverage",\n\?\s*"run",//g' "$f"
    done
  '';

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
