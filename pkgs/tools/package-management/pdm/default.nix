{ lib
, stdenv
, python3
, fetchFromGitHub
, fetchPypi
, nix-update-script
}:
let
  python = python3.override {
    # override resolvelib due to
    # 1. pdm requiring a later version of resolvelib
    # 2. Ansible being packaged as a library
    # 3. Ansible being unable to upgrade to a later version of resolvelib
    # see here for more details: https://github.com/NixOS/nixpkgs/pull/155380/files#r786255738
    packageOverrides = self: super: {
      resolvelib = super.resolvelib.overridePythonAttrs rec {
        version = "1.0.1";
        src = fetchFromGitHub {
          owner = "sarugaku";
          repo = "resolvelib";
          rev = "/refs/tags/${version}";
          hash = "sha256-oxyPn3aFPOyx/2aP7Eg2ThtPbyzrFT1JzWqy6GqNbzM=";
        };
      };
    };
    self = python;
  };
in

with python.pkgs;
buildPythonApplication rec {
  pname = "pdm";
  version = "2.8.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uUjQC/YgaCsKxMgNIoyzBaKwFQ5JfuaTHaMOPMMFv9w=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    blinker
    certifi
    cachecontrol
    findpython
    installer
    packaging
    platformdirs
    pyproject-hooks
    python-dotenv
    requests-toolbelt
    resolvelib
    rich
    shellingham
    tomlkit
    unearth
    virtualenv
  ]
  ++ cachecontrol.optional-dependencies.filecache
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ]
  ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-rerunfailures
    pytest-xdist
    pytest-httpserver
  ] ++ lib.optional stdenv.isLinux first;

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

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://pdm.fming.dev";
    changelog = "https://github.com/pdm-project/pdm/releases/tag/${version}";
    description = "A modern Python package manager with PEP 582 support";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
