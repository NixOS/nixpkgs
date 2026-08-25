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
  pytest9_0CheckHook,
  writableTmpDirAsHomeHook,
  procps,
}:

buildPythonPackage rec {
  pname = "typer";
  version = "0.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "typer";
    tag = version;
    hash = "sha256-HIvXseuR7zUXFuTWzntDfHhAp8BcFjxo35gn0i4+03w=";
  };

  postPatch = ''
    for f in $(find tests -type f -print); do
      # replace `sys.executable -m coverage run` with `sys.executable`
      sed -z -i 's/"-m",\n\?\s*"coverage",\n\?\s*"run",//g' "$f"
      # Click 8.4.0 changed the output format
      sed -i -E 's/"No such option: ([^"]*)"/"No such option '"'"'\1'"'"'"/g' "$f"
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
    pytest9_0CheckHook
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
    # Click 8.4.0 now provides typo suggestions, so disabling the pre-existing
    # typer option doesn't actually disable typo suggestions.
    # The click format is sufficiently similar to typer's that it causes this
    # test to fail.
    "test_typo_suggestion_disabled"
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
