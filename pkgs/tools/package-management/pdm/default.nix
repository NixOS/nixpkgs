{ lib
, python3
, fetchFromGitHub
, fetchPypi
, nix-update-script
, runtimeShell
, installShellFiles
, testers
, pdm
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
  version = "2.13.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4oK/HK8KCD/A+16JrW9518V5/1LHu1juhYfqPVu54Uo=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  build-system = [
    pdm-backend
  ];

  dependencies = [
    blinker
    dep-logic
    filelock
    findpython
    hishel
    httpx
    installer
    msgpack
    packaging
    pbs-installer
    platformdirs
    pyproject-hooks
    python-dotenv
    resolvelib
    rich
    shellingham
    tomlkit
    unearth
    virtualenv
  ] ++ httpx.optional-dependencies.socks
  ++ pbs-installer.optional-dependencies.install
  ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ]
  ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ]
  ++ lib.optionals (pythonAtLeast "3.10") [
    truststore
  ];

  makeWrapperArgs = [
    "--set PDM_CHECK_UPDATE 0"
  ];

  preInstall = ''
    # Silence network warning during pypaInstallPhase
    # by disabling latest version check
    export PDM_CHECK_UPDATE=0
  '';

  postInstall = ''
    export PDM_LOG_DIR=/tmp/pdm/log
    $out/bin/pdm completion bash >pdm.bash
    $out/bin/pdm completion fish >pdm.fish
    $out/bin/pdm completion zsh >pdm.zsh
    installShellCompletion pdm.{bash,fish,zsh}
    unset PDM_LOG_DIR
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-xdist
    pytest-httpserver
  ] ++ lib.optional stdenv.isLinux first;

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  preCheck = ''
    export HOME=$TMPDIR
    substituteInPlace tests/cli/test_run.py \
      --replace-warn "/bin/bash" "${runtimeShell}"
  '';

  disabledTests = [
    # fails to locate setuptools (maybe upstream bug)
    "test_convert_setup_py_project"
    # pythonfinder isn't aware of nix's python infrastructure
    "test_use_wrapper_python"

    # touches the network
    "test_find_candidates_from_find_links"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion {
    package = pdm;
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://pdm-project.org";
    changelog = "https://github.com/pdm-project/pdm/releases/tag/${version}";
    description = "A modern Python package and dependency manager supporting the latest PEP standards";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
    mainProgram = "pdm";
  };
}
