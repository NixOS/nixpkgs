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
        version = "0.9.0";
        src = fetchFromGitHub {
          owner = "sarugaku";
          repo = "resolvelib";
          rev = "/refs/tags/${version}";
          hash = "sha256-xzu8sMNMihJ80vezMdGkOT5Etx08qy3T/TkEn5EAY48=";
        };
      });
    };
    self = python;
  };
in

with python.pkgs;
buildPythonApplication rec {
  pname = "pdm";
  version = "2.3.4";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zaSNM5Ey4oI2MtUPYBHG0PCMgJdasVatwkjaRBrT1RQ=";
  };

  propagatedBuildInputs = [
    blinker
    cachecontrol
    certifi
    findpython
    installer
    packaging
    pdm-pep517
    pep517
    pip
    platformdirs
    pyproject-hooks
    python-dotenv
    requests-toolbelt
    resolvelib
    rich
    shellingham
    tomli
    tomlkit
    unearth
    virtualenv
  ]
  ++ cachecontrol.optional-dependencies.filecache
  ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
    typing-extensions
  ];

  nativeCheckInputs = [
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
    # fails to locate setuptools (maybe upstream bug)
    "test_convert_setup_py_project"
    # pythonfinder isn't aware of nix's python infrastructure
    "test_use_wrapper_python"
    "test_use_invalid_wrapper_python"
  ];

  meta = with lib; {
    homepage = "https://pdm.fming.dev";
    description = "A modern Python package manager with PEP 582 support";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
