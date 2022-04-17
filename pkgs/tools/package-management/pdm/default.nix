{ lib, python3, fetchFromGitHub, fetchurl }:
let
  python = python3.override {
    # override resolvelib due to
    # 1. pdm requiring a later version of resolvelib
    # 2. Ansible being packaged as a library
    # 3. Ansible being unable to upgrade to a later version of resolvelib
    # see here for more details: https://github.com/NixOS/nixpkgs/pull/155380/files#r786255738
    packageOverrides = self: super: {
      resolvelib = super.resolvelib.overridePythonAttrs (attrs: rec {
        version = "0.8.1";
        src = fetchFromGitHub {
          owner = "sarugaku";
          repo = "resolvelib";
          rev = version;
          sha256 = "sha256-QDHEdVET7HN2ZCKxNUMofabR+rxJy0erWhNQn94D7eI=";
        };
      });
    };
    self = python;
  };
in

with python.pkgs;
buildPythonApplication rec {
  pname = "pdm";
  version = "1.14.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZUbcuIRutSoHW5egCpwCKca2IZCgQsRAd72ueDzGySI=";
  };

  # this patch allows us to run additional tests that invoke pdm, which checks
  # itself for an update on every invocation by default, drammatically slowing
  # down test runs inside the sandbox
  #
  # the patch is necessary because the fixture is creating a project and
  # doesn't appear to respect the settings in `$HOME`; possibly a bug upstream
  patches = [
    ./check-update.patch
  ];

  propagatedBuildInputs = [
    blinker
    click
    findpython
    installer
    packaging
    pdm-pep517
    pep517
    pip
    platformdirs
    python-dotenv
    pythonfinder
    resolvelib
    shellingham
    tomli
    tomlkit
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
    pytest-xdist
  ];

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # sys.executable and expected executable are different
    "test_set_non_exist_python_path"
    # pythonfinder isn't aware of nix's python infrastructure
    "test_auto_isolate_site_packages"
    "test_use_wrapper_python"
    "test_find_python_in_path"
    # calls pip install and exits != 0
    "test_pre_and_post_hooks"
  ];

  meta = with lib; {
    homepage = "https://pdm.fming.dev";
    description = "A modern Python package manager with PEP 582 support";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
