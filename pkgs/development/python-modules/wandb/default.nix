{ lib
, stdenv
, azure-core
, bokeh
, buildPythonPackage
, click
, docker_pycreds
, fetchFromGitHub
, flask
, git
, gitpython
, jsonref
, jsonschema
, matplotlib
, nbclient
, nbformat
, pandas
, pathtools
, promise
, protobuf
, psutil
, pydantic
, pytest-mock
, pytest-xdist
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, torch
, pyyaml
, requests
, scikit-learn
, sentry-sdk
, setproctitle
, setuptools
, shortuuid
, substituteAll
, tqdm
}:

buildPythonPackage rec {
  pname = "wandb";
  version = "0.13.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-o9mIGSILztnHY3Eyb0MlznUEdMbCfA1BT6ux0UlesBc=";
  };

  patches = [
    # Replace git paths
    (substituteAll {
      src = ./hardcode-git-path.patch;
      git = "${lib.getBin git}/bin/git";
    })
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  # setuptools is necessary since pkg_resources is required at runtime.
  propagatedBuildInputs = [
    click
    docker_pycreds
    gitpython
    pathtools
    promise
    protobuf
    psutil
    pyyaml
    requests
    sentry-sdk
    setproctitle
    setuptools
    shortuuid
  ];

  nativeCheckInputs = [
    azure-core
    bokeh
    flask
    jsonref
    jsonschema
    matplotlib
    nbclient
    nbformat
    pandas
    pydantic
    pytest-mock
    pytest-xdist
    pytestCheckHook
    torch
    scikit-learn
    tqdm
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonRelaxDeps = [ "protobuf" ];

  disabledTestPaths = [
    # Tests that try to get chatty over sockets or spin up servers, not possible in the nix build environment.
    "tests/unit_tests_old/test_cli.py"
    "tests/unit_tests_old/test_data_types.py"
    "tests/unit_tests_old/test_file_stream.py"
    "tests/unit_tests_old/test_file_upload.py"
    "tests/unit_tests_old/test_footer.py"
    "tests/unit_tests_old/test_internal_api.py"
    "tests/unit_tests_old/test_keras.py"
    "tests/unit_tests_old/test_logging.py"
    "tests/unit_tests_old/test_metric_internal.py"
    "tests/unit_tests_old/test_public_api.py"
    "tests/unit_tests_old/test_report_api.py"
    "tests/unit_tests_old/test_runtime.py"
    "tests/unit_tests_old/test_sender.py"
    "tests/unit_tests_old/test_tb_watcher.py"
    "tests/unit_tests_old/test_time_resolution.py"
    "tests/unit_tests_old/test_wandb_agent.py"
    "tests/unit_tests_old/test_wandb_artifacts.py"
    "tests/unit_tests_old/test_wandb_integration.py"
    "tests/unit_tests_old/test_wandb_run.py"
    "tests/unit_tests/test_cli.py"
    "tests/unit_tests/test_data_types.py"
    "tests/unit_tests/test_file_upload.py"
    "tests/unit_tests/test_footer.py"
    "tests/unit_tests/test_internal_api.py"
    "tests/unit_tests/test_label_full.py"
    "tests/unit_tests/test_login.py"
    "tests/unit_tests/test_metric_full.py"
    "tests/unit_tests/test_metric_internal.py"
    "tests/unit_tests/test_mode_disabled.py"
    "tests/unit_tests/test_model_workflows.py"
    "tests/unit_tests/test_mp_full.py"
    "tests/unit_tests/test_plots.py"
    "tests/unit_tests/test_public_api.py"
    "tests/unit_tests/test_runtime.py"
    "tests/unit_tests/test_sender.py"
    "tests/unit_tests/test_start_method.py"
    "tests/unit_tests/test_tb_watcher.py"
    "tests/unit_tests/test_telemetry_full.py"
    "tests/unit_tests/test_util.py"

    # Tries to access /homeless-shelter
    "tests/unit_tests/test_tables.py"
  ];

  # Disable test that fails on darwin due to issue with python3Packages.psutil:
  # https://github.com/giampaolo/psutil/issues/1219
  disabledTests = lib.optionals stdenv.isDarwin [
    "test_tpu_system_stats"
  ];

  pythonImportsCheck = [
    "wandb"
  ];

  meta = with lib; {
    description = "A CLI and library for interacting with the Weights and Biases API";
    homepage = "https://github.com/wandb/wandb";
    changelog = "https://github.com/wandb/wandb/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
