{
  lib,
  fetchFromGitHub,
  python3Packages,
  beets,
  beetsPackages,
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-filetote";
  version = "0.4.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gtronset";
    repo = "beets-filetote";
    rev = "v${version}";
    hash = "sha256-pZ6c2XQMSiiPHyZMLSiSE+LXeCfi3HEWtsTK5DP9YZE=";
  };

  postPatch = ''
    sed -i -e '/install_requires/,/\]/{/beets/d}' setup.py
    sed -i -e '/namespace_packages/d' setup.py
    printf 'from pkgutil import extend_path\n__path__ = extend_path(__path__, __name__)\n' >beetsplug/__init__.py

    # beets v2.1.0 compat
    # <https://github.com/beetbox/beets/commit/0e87389994a9969fa0930ffaa607609d02e286a8>
    sed -i -e 's/util\.py3_path/os.fsdecode/g' tests/_common.py
  '';

  build-system = [ python3Packages.poetry-core ];

  dependencies =
    [ beets ]
    ++ (with python3Packages; [
      mediafile
      reflink
      toml
      typeguard
    ]);

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

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [ python3Packages.pytestCheckHook ] ++ optional-dependencies.test;

  meta = with lib; {
    description = "Beets plugin to move non-music files during the import process";
    homepage = "https://github.com/gtronset/beets-filetote";
    changelog = "https://github.com/gtronset/beets-filetote/blob/${src.rev}/CHANGELOG.md";
    maintainers = with maintainers; [ dansbandit ];
    license = licenses.mit;
    inherit (beets.meta) platforms;
  };
}
