{
  lib,
  fetchFromGitHub,
  python3Packages,
  beets,
  beetsPackages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-filetote";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gtronset";
    repo = "beets-filetote";
    tag = "v${version}";
    hash = "sha256-LTJwZI/kQc+Iv0y8jAi5Xdh4wLEwbTA9hV76ndQsQzU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "poetry-core<2.0.0" "poetry-core"
  '';

  nativeBuildInputs = [
    beets
  ];

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    mediafile
    reflink
    toml
    typeguard
  ];

  optional-dependencies = {
    lint = with python3Packages; [
      black
      check-manifest
      flake8
      flake8-bugbear
      flake8-bugbear-pyi
      isort
      mypy
      pylint
      typing_extensions
    ];
    test = with python3Packages; [
      beetsPackages.audible
      mediafile
      pytest
      reflink
      toml
      typeguard
    ];
    dev = optional-dependencies.lint ++ optional-dependencies.test ++ [ python3Packages.tox ];
  };

  pytestFlagsArray = [ "-r fEs" ];

  disabledTestPaths = [
    "tests/test_cli_operation.py"
    "tests/test_pruning.py"
    "tests/test_version.py"
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ] ++ optional-dependencies.test;

  meta = with lib; {
    description = "Beets plugin to move non-music files during the import process";
    homepage = "https://github.com/gtronset/beets-filetote";
    changelog = "https://github.com/gtronset/beets-filetote/blob/${src.rev}/CHANGELOG.md";
    maintainers = with maintainers; [ dansbandit ];
    license = licenses.mit;
    inherit (beets.meta) platforms;
  };
}
