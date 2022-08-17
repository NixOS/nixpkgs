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
, GitPython
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
, python-dateutil
, pythonOlder
, pytorch
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
  version = "0.12.21";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "client";
    rev = "refs/tags/v${version}";
    hash = "sha256-jKb2pNmCW4MYz6ncsMNg7o5giCI2bpKER/kb8lfJekI=";
  };

  patches = [
    (substituteAll {
      src = ./hardcode-git-path.patch;
      git = "${lib.getBin git}/bin/git";
    })
  ];

  # setuptools is necessary since pkg_resources is required at runtime.
  propagatedBuildInputs = [
    click
    docker_pycreds
    GitPython
    pathtools
    promise
    protobuf
    psutil
    python-dateutil
    pyyaml
    requests
    sentry-sdk
    setproctitle
    setuptools
    shortuuid
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkInputs = [
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
    pytorch
    scikit-learn
    tqdm
  ];

  disabledTestPaths = [
    # Tests that try to get chatty over sockets or spin up servers, not possible in the nix build environment.
    "tests/unit_tests/integrations/test_keras.py"
    "tests/unit_tests/integrations/test_torch.py"
    "tests/unit_tests/test_cli.py"
    "tests/unit_tests/test_data_types.py"
    "tests/unit_tests/test_file_stream.py"
    "tests/unit_tests/test_file_upload.py"
    "tests/unit_tests/test_footer.py"
    "tests/unit_tests/test_internal_api.py"
    "tests/unit_tests/test_label_full.py"
    "tests/unit_tests/test_login.py"
    "tests/unit_tests/test_meta.py"
    "tests/unit_tests/test_metric_full.py"
    "tests/unit_tests/test_metric_internal.py"
    "tests/unit_tests/test_mode_disabled.py"
    "tests/unit_tests/test_model_workflows.py"
    "tests/unit_tests/test_mp_full.py"
    "tests/unit_tests/test_public_api.py"
    "tests/unit_tests/test_redir.py"
    "tests/unit_tests/test_runtime.py"
    "tests/unit_tests/test_sender.py"
    "tests/unit_tests/test_start_method.py"
    "tests/unit_tests/test_tb_watcher.py"
    "tests/unit_tests/test_telemetry_full.py"
    "tests/unit_tests/test_util.py"
    "tests/unit_tests/wandb_agent_test.py"
    "tests/unit_tests/wandb_artifacts_test.py"
    "tests/unit_tests/wandb_integration_test.py"
    "tests/unit_tests/wandb_run_test.py"
    "tests/unit_tests/wandb_settings_test.py"
    "tests/unit_tests/wandb_sweep_test.py"
    "tests/unit_tests/wandb_tensorflow_test.py"
    "tests/unit_tests/wandb_verify_test.py"
    "tests/unit_tests/test_tpu.py"
    "tests/unit_tests/test_plots.py"
    "tests/unit_tests/test_report_api.py"

    # Requires metaflow, which is not yet packaged.
    "tests/unit_tests/integrations/test_metaflow.py"

    # Fails and borks the pytest runner as well.
    "tests/unit_tests/wandb_test.py"

    # Tries to access /homeless-shelter
    "tests/unit_tests/test_tables.py"
  ];

  # Disable test that fails on darwin due to issue with python3Packages.psutil:
  # https://github.com/giampaolo/psutil/issues/1219
  disabledTests = lib.optional stdenv.isDarwin [
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
