{
  lib,
  buildPythonPackage,
  fetchPypi,

  cmake,
  ninja,
  zig_0_16,
  # build-system
  hatchling,
  scikit-build-core,
  hatch-vcs,
  nanobind,
  # deps
  anthropic,
  antlr4-python3-runtime,
  atopile-easyeda2kicad,
  atopile-kicad-python,
  black,
  case-converter,
  cookiecutter,
  dataclasses-json,
  deprecated,
  fastapi,
  fastapi-github-oidc,
  freetype-py,
  gitpython,
  httpx,
  jinja2,
  keyring,
  kicadcliwrapper,
  matplotlib,
  mcp,
  more-itertools,
  natsort,
  numpy,
  openai,
  ordered-set,
  pathvalidate,
  pint,
  platformdirs,
  prompt-toolkit,
  psutil,
  pyaaf2,
  pydantic-settings,
  pygls,
  pytest,
  pyyaml,
  questionary,
  rich,
  ruamel-yaml,
  ruff,
  semver,
  sexpdata,
  shapely,
  truststore,
  typer,
  typing-extensions,
  urllib3,
  uvicorn,
  watchdog,
  websockets,
  zstd,
  pythonOlder,

  # tests
  gitMinimal,
  hypothesis,
  pytest-xdist,
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "atopile";
  version = "0.15.9";
  pyproject = true;

  disabled = pythonOlder "3.14";

  # Upstream stopped pushing tags (and commits) to GitHub after v0.14.x.
  # The PyPI sdist also ships the PKG-INFO metadata needed by hatch-vcs.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-aBzB4SNkbdEz3jG2Ma7a9OqsiGgmE7T4LR2ks++LTo4=";
  };

  # Upstream pins a fork of scikit-build-core (editable-mode patch) we don't need.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        'scikit-build-core @ git+https://github.com/atopile/scikit-build-core.git@feature/allow_editable' \
        'scikit-build-core' \
      --replace-fail '"ziglang==0.16.0",' ""
  '';

  build-system = [
    hatchling
    scikit-build-core
    hatch-vcs
    nanobind
  ];

  dontUseCmakeConfigure = true; # skip cmake configure invocation

  # The CMake build shells out to `python -m ziglang ...` (the ziglang pip
  # wheel, not packaged in nixpkgs). Provide a shim module that execs the real
  # zig, and give zig a writable cache dir.
  preBuild = ''
    mkdir -p zigshim/ziglang
    touch zigshim/ziglang/__init__.py
    printf 'import os, sys\nos.execv("%s/bin/zig", ["zig", *sys.argv[1:]])\n' "${zig_0_16}" > zigshim/ziglang/__main__.py
    export PYTHONPATH="$PWD/zigshim:$PYTHONPATH"
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    zig_0_16 # replaces the ziglang pip build-dep; build calls zig to compile faebryk core
  ];

  dependencies = [
    anthropic
    antlr4-python3-runtime
    atopile-easyeda2kicad
    atopile-kicad-python
    black # used as a dependency
    case-converter
    cookiecutter
    dataclasses-json
    deprecated
    fastapi
    fastapi-github-oidc
    freetype-py
    gitpython
    httpx
    jinja2
    keyring
    kicadcliwrapper
    matplotlib
    mcp
    more-itertools
    nanobind
    natsort
    numpy
    openai
    ordered-set
    pathvalidate
    pint
    platformdirs
    prompt-toolkit
    psutil
    pyaaf2
    pydantic-settings
    pygls
    pytest # imported at runtime
    pyyaml
    questionary
    rich
    ruamel-yaml
    ruff
    semver
    sexpdata
    shapely
    truststore
    typer
    typing-extensions
    urllib3
    uvicorn
    watchdog
    websockets
    zstd
  ]
  ++ mcp.optional-dependencies.cli;

  pythonRelaxDeps = [
    "deprecated"
    "prompt-toolkit"
    "ruff"
  ];

  pythonImportsCheck = [ "atopile" ];

  nativeCheckInputs = [
    gitMinimal
    hypothesis
    pytest-xdist
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  env.SKIP_EASYEDA = "1";

  preCheck =
    # Use a per-worker log dir: workers racing on the shared sqlite log DB at
    # collection time cause `sqlite3.OperationalError: disk I/O error`.
    # Also, app_root()/repo_root() look for pyproject.toml/.git above the installed module.
    ''
      cat - conftest.py > conftest.py.new <<EOF
      import os
      from pathlib import Path
      if (worker := os.environ.get("PYTEST_XDIST_WORKER")) is not None:
          os.environ["FBRK_LOG_DIR"] = os.path.join(os.environ["HOME"], "atopile-logs", worker)
      import faebryk.libs.util
      faebryk.libs.util.app_root = faebryk.libs.util.repo_root = lambda: Path("$PWD")
      EOF
      mv conftest.py.new conftest.py
    '';

  # Only run the tests under test/ (testpaths also includes src/)
  enabledTestPaths = [ "test" ];

  disabledTestMarks = [
    "easyeda"
    "full_solver_only"
    "not_in_ci"
    "regression"
    "slow"
  ];

  disabledTests = [
    # Requires internet access
    "test_install_package"

    # Subprocess can't find the app root (pyproject.toml)
    "test_dev_flags_runs_and_prints_table_title"

    # pydantic_core._pydantic_core.ValidationError: 1 validation error for InputTokensDetails
    "test_extracts_usage_tokens"

    # AssertionError: assert None is not None
    "test_structure_refresh_recovers_after_introspection_failure"
  ];

  meta = {
    description = "Design circuit boards with code";
    homepage = "https://atopile.io";
    downloadPage = "https://github.com/atopile/atopile";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thecodedkid ];
    mainProgram = "ato";
  };
})
