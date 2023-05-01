{ lib
, stdenv
, appdirs
, azure-core
, bokeh
, boto3
, buildPythonPackage
, click
, docker_pycreds
, fetchFromGitHub
, flask
, git
, gitpython
, google-cloud-compute
, google-cloud-storage
, hypothesis
, jsonref
, jsonschema
, keras
, kubernetes
, matplotlib
, mlflow
, nbclient
, nbformat
, pandas
, parameterized
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
, pyyaml
, requests
, responses
, scikit-learn
, sentry-sdk
, setproctitle
, setuptools
, shortuuid
, substituteAll
, tensorflow
, torch
, tqdm
}:

buildPythonPackage rec {
  pname = "wandb";
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-UULsvvk9BsWUrJ8eD7uD2UnUJqmPrmjrJvCA7WRC/Cw=";
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
    appdirs
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
    boto3
    flask
    google-cloud-compute
    google-cloud-storage
    hypothesis
    jsonref
    jsonschema
    keras
    kubernetes
    matplotlib
    mlflow
    nbclient
    nbformat
    pandas
    parameterized
    pydantic
    pytest-mock
    pytest-xdist
    pytestCheckHook
    responses
    scikit-learn
    tensorflow
    torch
    tqdm
  ];

  # Set BOKEH_CDN_VERSION to stop bokeh throwing an exception in tests
  preCheck = ''
    export HOME=$(mktemp -d)
    export BOKEH_CDN_VERSION=${bokeh.version}
  '';

  pythonRelaxDeps = [ "protobuf" ];

  disabledTestPaths = [
    # Tests that try to get chatty over sockets or spin up servers, not possible in the nix build environment.
    "tests/pytest_tests/unit_tests_old/test_cli.py"
    "tests/pytest_tests/unit_tests_old/test_data_types.py"
    "tests/pytest_tests/unit_tests_old/test_file_stream.py"
    "tests/pytest_tests/unit_tests_old/test_file_upload.py"
    "tests/pytest_tests/unit_tests_old/test_footer.py"
    "tests/pytest_tests/unit_tests_old/test_internal_api.py"
    "tests/pytest_tests/unit_tests_old/test_keras.py"
    "tests/pytest_tests/unit_tests_old/test_logging.py"
    "tests/pytest_tests/unit_tests_old/test_metric_internal.py"
    "tests/pytest_tests/unit_tests_old/test_public_api.py"
    "tests/pytest_tests/unit_tests_old/test_runtime.py"
    "tests/pytest_tests/unit_tests_old/test_sender.py"
    "tests/pytest_tests/unit_tests_old/test_summary.py"
    "tests/pytest_tests/unit_tests_old/test_tb_watcher.py"
    "tests/pytest_tests/unit_tests_old/test_time_resolution.py"
    "tests/pytest_tests/unit_tests_old/test_wandb_agent.py"
    "tests/pytest_tests/unit_tests_old/test_wandb_artifacts.py"
    "tests/pytest_tests/unit_tests_old/test_wandb_integration.py"
    "tests/pytest_tests/unit_tests_old/test_wandb_run.py"
    "tests/pytest_tests/unit_tests_old/test_wandb.py"
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_aws.py"
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_cli.py"
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_docker.py"
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_kubernetes.py"
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch.py"
    "tests/pytest_tests/unit_tests_old/tests_s_nb/test_notebooks.py"
    "tests/pytest_tests/unit_tests/test_cli.py"
    "tests/pytest_tests/unit_tests/test_data_types.py"
    "tests/pytest_tests/unit_tests/test_internal_api.py"
    "tests/pytest_tests/unit_tests/test_mode_disabled.py"
    "tests/pytest_tests/unit_tests/test_model_workflows.py"
    "tests/pytest_tests/unit_tests/test_plots.py"
    "tests/pytest_tests/unit_tests/test_public_api.py"
    "tests/pytest_tests/unit_tests/test_sender.py"
    "tests/pytest_tests/unit_tests/test_util.py"
    "tests/pytest_tests/unit_tests/test_wandb_verify.py"

    # Requires docker access
    "tests/pytest_tests/system_tests/test_artifacts/test_artifact_saver.py"
    "tests/pytest_tests/system_tests/test_artifacts/test_wandb_artifacts_full.py"
    "tests/pytest_tests/system_tests/test_artifacts/test_wandb_artifacts.py"
    "tests/pytest_tests/system_tests/test_core/test_cli_full.py"
    "tests/pytest_tests/system_tests/test_core/test_data_types_full.py"
    "tests/pytest_tests/system_tests/test_core/test_file_stream_internal.py"
    "tests/pytest_tests/system_tests/test_core/test_file_upload.py"
    "tests/pytest_tests/system_tests/test_core/test_footer.py"
    "tests/pytest_tests/system_tests/test_core/test_keras_full.py"
    "tests/pytest_tests/system_tests/test_core/test_label_full.py"
    "tests/pytest_tests/system_tests/test_core/test_metric_full.py"
    "tests/pytest_tests/system_tests/test_core/test_metric_internal.py"
    "tests/pytest_tests/system_tests/test_core/test_mode_disabled_full.py"
    "tests/pytest_tests/system_tests/test_core/test_model_workflow.py"
    "tests/pytest_tests/system_tests/test_core/test_mp_full.py"
    "tests/pytest_tests/system_tests/test_core/test_public_api.py"
    "tests/pytest_tests/system_tests/test_core/test_redir_full.py"
    "tests/pytest_tests/system_tests/test_core/test_report_api.py"
    "tests/pytest_tests/system_tests/test_core/test_runtime.py"
    "tests/pytest_tests/system_tests/test_core/test_save_policies.py"
    "tests/pytest_tests/system_tests/test_core/test_sender.py"
    "tests/pytest_tests/system_tests/test_core/test_start_method.py"
    "tests/pytest_tests/system_tests/test_core/test_system_info.py"
    "tests/pytest_tests/system_tests/test_core/test_tb_watcher.py"
    "tests/pytest_tests/system_tests/test_core/test_telemetry_full.py"
    "tests/pytest_tests/system_tests/test_core/test_time_resolution.py"
    "tests/pytest_tests/system_tests/test_core/test_torch_full.py"
    "tests/pytest_tests/system_tests/test_core/test_validation_data_logger.py"
    "tests/pytest_tests/system_tests/test_core/test_wandb_integration.py"
    "tests/pytest_tests/system_tests/test_core/test_wandb_run.py"
    "tests/pytest_tests/system_tests/test_core/test_wandb_settings.py"
    "tests/pytest_tests/system_tests/test_core/test_wandb_tensorflow.py"
    "tests/pytest_tests/system_tests/test_core/test_wandb_verify.py"
    "tests/pytest_tests/system_tests/test_core/test_wandb.py"
    "tests/pytest_tests/system_tests/test_importers/test_import_mlflow.py"
    "tests/pytest_tests/system_tests/test_sweep/test_public_api.py"
    "tests/pytest_tests/system_tests/test_sweep/test_sweep_scheduler.py"
    "tests/pytest_tests/system_tests/test_sweep/test_wandb_agent_full.py"
    "tests/pytest_tests/system_tests/test_sweep/test_wandb_agent.py"
    "tests/pytest_tests/system_tests/test_sweep/test_wandb_sweep.py"
    "tests/pytest_tests/system_tests/tests_launch/test_github_reference.py"
    "tests/pytest_tests/system_tests/tests_launch/test_job.py"
    "tests/pytest_tests/system_tests/tests_launch/test_launch_add.py"
    "tests/pytest_tests/system_tests/tests_launch/test_launch_cli.py"
    "tests/pytest_tests/system_tests/tests_launch/test_launch_kubernetes.py"
    "tests/pytest_tests/system_tests/tests_launch/test_launch_local_container.py"
    "tests/pytest_tests/system_tests/tests_launch/test_launch_run.py"
    "tests/pytest_tests/system_tests/tests_launch/test_launch_sweep.py"
    "tests/pytest_tests/system_tests/tests_launch/test_launch.py"
    "tests/pytest_tests/system_tests/tests_launch/test_wandb_reference.py"

    # Tries to access /homeless-shelter
    "tests/pytest_tests/unit_tests/test_tables.py"

    # E       AssertionError: assert 'Cannot use both --async and --queue with wandb launch' in 'wandb: ERROR Find detailed error logs at: /build/source/wandb/debug-cli.nixbld.log\nError: The wandb service process exited with 1. Ensure that `sys.executable` is a valid python interpreter. You can override it with the `_executable` setting or with the `WANDB__EXECUTABLE` environment variable.\n'
    # E        +  where 'wandb: ERROR Find detailed error logs at: /build/source/wandb/debug-cli.nixbld.log\nError: The wandb service process exited with 1. Ensure that `sys.executable` is a valid python interpreter. You can override it with the `_executable` setting or with the `WANDB__EXECUTABLE` environment variable.\n' = <Result SystemExit(1)>.output
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_jobs.py"

    # Requires google-cloud-aiplatform which is not packaged as of 2023-04-25.
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_gcp.py"

    # Requires google-cloud-artifact-registry which is not packaged as of 2023-04-25.
    "tests/pytest_tests/unit_tests_old/tests_launch/test_kaniko_build.py"
    "tests/pytest_tests/unit_tests/test_launch/test_registry/test_gcp_artifact_registry.py"

    # Requires kfp which is not packaged as of 2023-04-25.
    "tests/pytest_tests/system_tests/test_core/test_kfp.py"

    # Requires metaflow which is not packaged as of 2023-04-25.
    "tests/pytest_tests/unit_tests/test_metaflow.py"

    # See https://github.com/wandb/wandb/issues/5423
    "tests/pytest_tests/unit_tests/test_docker.py"
    "tests/pytest_tests/unit_tests/test_library_public.py"
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
