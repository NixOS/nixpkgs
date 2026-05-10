{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  annotated-doc,

  # optional-dependencies
  rich,
  shellingham,

  # tests
  pytest-xdist,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  procps,
}:

buildPythonPackage (finalAttrs: {
  pname = "typer";
  version = "0.26.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "typer";
    tag = finalAttrs.version;
    hash = "sha256-VkqvlWLzmtbQPaplx/YRdSNN1xq/UMRl8EZVIEm97Lk=";
  };

  patches = [ ./fix-binary-stderr-test.patch ];

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
    # Flaky sometimes
    "test_file_error"

    "test_scripts"

    # Likely related to https://github.com/sarugaku/shellingham/issues/35
    # fails also on Linux
    "test_show_completion"
    "test_install_completion"
  ];

  pythonImportsCheck = [ "typer" ];

  meta = {
    description = "Library for building CLI applications";
    homepage = "https://typer.tiangolo.com/";
    changelog = "https://github.com/tiangolo/typer/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ winpat ];
  };
})
