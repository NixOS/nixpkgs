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
  version = "0.12.17";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = "client";
    rev = "v${version}";
    hash = "sha256-hY01cql/j3ieL1zJoPOM/QZiF0X/ivekFRfX+TvZhyM=";
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
    scikit-learn
    tqdm
  ];

  disabledTestPaths = [
    # Tests that try to get chatty over sockets or spin up servers, not possible in the nix build environment.
    "tests/test_cli.py"
    "tests/test_data_types.py"
    "tests/test_file_stream.py"
    "tests/test_file_upload.py"
    "tests/test_footer.py"
    "tests/test_internal_api.py"
    "tests/test_label_full.py"
    "tests/test_login.py"
    "tests/test_meta.py"
    "tests/test_metric_full.py"
    "tests/test_metric_internal.py"
    "tests/test_mode_disabled.py"
    "tests/test_mp_full.py"
    "tests/test_public_api.py"
    "tests/test_redir.py"
    "tests/test_runtime.py"
    "tests/test_sender.py"
    "tests/test_start_method.py"
    "tests/test_tb_watcher.py"
    "tests/test_telemetry_full.py"
    "tests/wandb_agent_test.py"
    "tests/wandb_artifacts_test.py"
    "tests/wandb_integration_test.py"
    "tests/wandb_run_test.py"
    "tests/wandb_settings_test.py"
    "tests/wandb_sweep_test.py"
    "tests/wandb_verify_test.py"
    "tests/test_model_workflows.py"

    # Fails and borks the pytest runner as well.
    "tests/wandb_test.py"

    # Tries to access /homeless-shelter
    "tests/test_tables.py"
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
    homepage = "https://github.com/wandb/client";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
