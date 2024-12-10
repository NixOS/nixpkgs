{
  lib,
  python3,
  fetchFromGitHub,
  godot3-server,
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      lark = super.lark.overridePythonAttrs (old: rec {
        # gdtoolkit needs exactly this lark version
        version = "0.8.0";
        src = fetchFromGitHub {
          owner = "lark-parser";
          repo = "lark";
          rev = version;
          hash = "sha256-KN9buVlH8hJ8t0ZP5yefeYM5vH5Gg7a7TEDGKJYpozs=";
          fetchSubmodules = true;
        };
        patches = [ ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "gdtoolkit";
  version = "3.3.1";

  # If we try to get using fetchPypi it requires GeoIP (but the package dont has that dep!?)
  src = fetchFromGitHub {
    owner = "Scony";
    repo = "godot-gdscript-toolkit";
    rev = version;
    sha256 = "13nnpwy550jf5qnm9ixpxl1bwfnhhbiys8vqfd25g3aim4bm3gnn";
  };

  disabled = python.pythonOlder "3.7";

  propagatedBuildInputs = with python.pkgs; [
    docopt
    lark
    pyyaml
    setuptools
  ];

  doCheck = true;

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
    hypothesis
    godot3-server
  ];

  preCheck =
    let
      godotServerMajorVersion = lib.versions.major godot3-server.version;
      gdtoolkitMajorVersion = lib.versions.major version;
      msg = ''
        gdtoolkit major version ${gdtoolkitMajorVersion} does not match godot-server major version ${godotServerMajorVersion}!
        gdtoolkit needs a matching godot-server for its tests.
        If you see this error, you can either:
         - disable doCheck for gdtoolkit, or
         - provide a compatible godot-server version to gdtoolkit"
      '';
    in
    lib.throwIf (godotServerMajorVersion != gdtoolkitMajorVersion) msg ''
      # The tests want to run the installed executables
      export PATH=$out/bin:$PATH

      # gdtoolkit tries to write cache variables to $HOME/.cache
      export HOME=$TMP

      # Work around https://github.com/godotengine/godot/issues/20503
      # Without this, Godot will complain about a missing project file
      touch project.godot

      # Remove broken test case
      # (hard to skip via disabledTests since the test name contains an absolute path)
      rm tests/potential-godot-bugs/multiline-subscription-expression.gd
    '';

  pythonImportsCheck = [
    "gdtoolkit"
    "gdtoolkit.formatter"
    "gdtoolkit.linter"
    "gdtoolkit.parser"
  ];

  meta = with lib; {
    description = "Independent set of tools for working with Godot's GDScript - parser, linter and formatter";
    homepage = "https://github.com/Scony/godot-gdscript-toolkit";
    license = licenses.mit;
    maintainers = with maintainers; [
      shiryel
      tmarkus
    ];
  };
}
