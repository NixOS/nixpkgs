{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  annotated-doc,
  rich,
  shellingham,

  # tests
  pytest-xdist,
  pytest9_0CheckHook,
  writableTmpDirAsHomeHook,
  procps,
}:

buildPythonPackage (finalAttrs: {
  pname = "typer";
  version = "0.27.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi";
    repo = "typer";
    tag = finalAttrs.version;
    hash = "sha256-vBHSJoyIQawkqqhbPJGKzPjBPm42OR/Ref/k6XFJTi8=";
  };

  postPatch = ''
    for f in $(find tests -type f -print); do
      # replace `sys.executable -m coverage run` with `sys.executable`
      sed -z -i 's/"-m",\n\?\s*"coverage",\n\?\s*"run",//g' "$f"
      sed -i 's/-m coverage run//g' "$f"
    done
  ''
  # These are already included in the PYTHONPATH.
  # Overriding PYTHONPATH breaks the tests when executed by Nix ("No module named 'typer'" error)
  # because it's used to find `typer` too.
  + ''
    substituteInPlace tests/test_tutorial/test_subcommands/test_tutorial001.py \
      --replace-fail 'env["PYTHONPATH"] = ":".join(list(tutorial001_py310.__path__))' ""
    substituteInPlace tests/test_tutorial/test_subcommands/test_tutorial003.py \
      --replace-fail 'env["PYTHONPATH"] = ":".join(list(tutorial003_py310.__path__))' ""
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
    pytest9_0CheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    procps
  ];

  preCheck =
    # Fix "No module named 'tests'" error in tests/test_types_file.py::test_binary_stderr
    ''
      export PYTHONPATH="$PWD:$PYTHONPATH"
    ''
    # Match upstream's scripts/test.sh. Otherwise rich wraps output at 80 columns, and
    # test_file_error fails with 11 or more xdist workers (popen-gw10 and up), whose longer tmp_path
    # gets split mid-name.
    + ''
      export TERMINAL_WIDTH=3000
    '';

  # Long Nix build paths can make Rich wrap the filename in the error message.
  # https://github.com/fastapi/typer/discussions/1984
  disabledTests = [ "test_file_error" ];

  pythonImportsCheck = [ "typer" ];

  meta = {
    description = "Library for building CLI applications";
    homepage = "https://typer.tiangolo.com/";
    changelog = "https://github.com/tiangolo/typer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ winpat ];
  };
})
