{
  lib,
  python3,
  fetchFromGitHub,
  runtimeShell,
  installShellFiles,
  testers,
  pdm,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pdm";
  version = "2.18.1";
  pyproject = true;

  disabled = python3.pkgs.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pdm-project";
    repo = "pdm";
    rev = "refs/tags/${version}";
    hash = "sha256-pCBwt55tu9bEVVHfdPsJ5vaJXVXEZ2+4ft9LathwBt0=";
  };

  nativeBuildInputs = [ installShellFiles ];

  build-system = with python3.pkgs; [
    pdm-backend
    pdm-build-locked
  ];

  dependencies =
    with python3.pkgs;
    [
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
      truststore
      unearth
      virtualenv
    ]
    ++ httpx.optional-dependencies.socks;

  makeWrapperArgs = [ "--set PDM_CHECK_UPDATE 0" ];

  # Silence network warning during pypaInstallPhase
  # by disabling latest version check
  preInstall = ''
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

  nativeCheckInputs = with python3.pkgs; [
    first
    pytestCheckHook
    pytest-mock
    pytest-xdist
    pytest-httpserver
  ];

  pytestFlagsArray = [ "-m 'not network'" ];

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
    "test_build_with_no_isolation"
    "test_run_script_with_inline_metadata"

    # touches the network
    "test_find_candidates_from_find_links"
    "test_lock_all_with_excluded_groups"
    "test_find_interpreters_with_PDM_IGNORE_ACTIVE_VENV"
    "test_build_distributions"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests.version = testers.testVersion { package = pdm; };

  meta = with lib; {
    homepage = "https://pdm-project.org";
    changelog = "https://github.com/pdm-project/pdm/releases/tag/${version}";
    description = "Modern Python package and dependency manager supporting the latest PEP standards";
    license = licenses.mit;
    maintainers = with maintainers; [
      cpcloud
      natsukium
    ];
    mainProgram = "pdm";
  };
}
