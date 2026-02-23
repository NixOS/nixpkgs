{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  annotated-doc,
  click,

  # optional-dependencies
  rich,
  shellingham,

  # tests
  pytest-xdist,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  procps,
}:

buildPythonPackage rec {
  pname = "typer";
  version = "0.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "typer";
    tag = version;
    hash = "sha256-ha/cT2+I9/WUjb7ZXSKqLSocZ3vq0N1fm4RvRpsXIDc=";
  };

  postPatch = ''
    for f in $(find tests -type f -print); do
      # replace `sys.executable -m coverage run` with `sys.executable`
      sed -z -i 's/"-m",\n\?\s*"coverage",\n\?\s*"run",//g' "$f"
    done
  '';

  env.TIANGOLO_BUILD_PACKAGE = "typer";

  build-system = [ pdm-backend ];

  dependencies = [
    annotated-doc
    click
    rich
    shellingham
  ];

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
