{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pyxdg,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "scspell";
  version = "2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "myint";
    repo = "scspell";
    tag = "v${version}";
    hash = "sha256-XiUdz+uHOJlqo+TWd1V/PvzkGJ2kPXzJJSe5Smfdgec=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyxdg
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  passthru.tests = {
    version = {
      command = [
        "scspell"
        "--version"
      ];
    };
    help = {
      command = [
        "scspell"
        "--help"
      ];
    };
    basic-check = {
      command = ''
        export HOME=$TMPDIR
        cat > test_file.py << 'EOF'
        def hello_world():
            print("Hello, world!")
        EOF
        scspell test_file.py
      '';
    };
    updateScript = nix-update-script {
      attrPath = "pythonPackages.${pname}";
    };
  };

  pythonImportsCheck = [ "scspell" ];

  meta = {
    description = "A spell checker for source code";
    homepage = "https://github.com/myint/scspell";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ guelakais ];
    mainProgram = "scspell";
  };
}
