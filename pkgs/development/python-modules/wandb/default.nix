{ lib
, stdenv
, appdirs
<<<<<<< HEAD
, azure-containerregistry
, azure-core
, azure-identity
, azure-storage-blob
=======
, azure-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, bokeh
, boto3
, buildPythonPackage
, click
, docker_pycreds
, fetchFromGitHub
, flask
, git
, gitpython
<<<<<<< HEAD
, google-cloud-artifact-registry
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, protobuf
, psutil
, pydantic
, pyfakefs
=======
, promise
, protobuf
, psutil
, pydantic
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, substituteAll
=======
, shortuuid
, substituteAll
, tensorflow
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, torch
, tqdm
}:

buildPythonPackage rec {
  pname = "wandb";
<<<<<<< HEAD
  version = "0.15.10";
  format = "pyproject";
=======
  version = "0.15.0";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-MuYaeg7+lMOOSalnLyKsCw+f44daDDayvyKvY8z697c=";
=======
    hash = "sha256-UULsvvk9BsWUrJ8eD7uD2UnUJqmPrmjrJvCA7WRC/Cw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    setuptools
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # setuptools is necessary since pkg_resources is required at runtime.
  propagatedBuildInputs = [
    appdirs
    click
    docker_pycreds
    gitpython
    pathtools
<<<<<<< HEAD
=======
    promise
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    protobuf
    psutil
    pyyaml
    requests
    sentry-sdk
    setproctitle
    setuptools
<<<<<<< HEAD
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    azure-containerregistry
    azure-core
    azure-identity
    azure-storage-blob
    bokeh
    boto3
    flask
    google-cloud-artifact-registry
=======
    shortuuid
  ];

  nativeCheckInputs = [
    azure-core
    bokeh
    boto3
    flask
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    pyfakefs
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-mock
    pytest-xdist
    pytestCheckHook
    responses
    scikit-learn
<<<<<<< HEAD
=======
    tensorflow
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    torch
    tqdm
  ];

  # Set BOKEH_CDN_VERSION to stop bokeh throwing an exception in tests
  preCheck = ''
    export HOME=$(mktemp -d)
    export BOKEH_CDN_VERSION=${bokeh.version}
  '';

  pythonRelaxDeps = [ "protobuf" ];

<<<<<<< HEAD
  pytestFlagsArray = [
    # We want to run only unit tests
    "tests/pytest_tests"
  ];

  disabledTestPaths = [
    # Tests that try to get chatty over sockets or spin up servers, not possible in the nix build environment.
    "tests/pytest_tests/system_tests/test_notebooks/test_notebooks.py"
=======
  disabledTestPaths = [
    # Tests that try to get chatty over sockets or spin up servers, not possible in the nix build environment.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch.py"
=======
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_kubernetes.py"
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch.py"
    "tests/pytest_tests/unit_tests_old/tests_s_nb/test_notebooks.py"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    "tests/pytest_tests/system_tests/test_core/test_wandb_init.py"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "tests/pytest_tests/system_tests/test_core/test_wandb_integration.py"
    "tests/pytest_tests/system_tests/test_core/test_wandb_run.py"
    "tests/pytest_tests/system_tests/test_core/test_wandb_settings.py"
    "tests/pytest_tests/system_tests/test_core/test_wandb_tensorflow.py"
    "tests/pytest_tests/system_tests/test_core/test_wandb_verify.py"
    "tests/pytest_tests/system_tests/test_core/test_wandb.py"
    "tests/pytest_tests/system_tests/test_importers/test_import_mlflow.py"
<<<<<<< HEAD
    "tests/pytest_tests/system_tests/test_nexus/test_nexus.py"
    "tests/pytest_tests/system_tests/test_sweep/test_public_api.py"
    "tests/pytest_tests/system_tests/test_sweep/test_sweep_scheduler.py"
    "tests/pytest_tests/system_tests/test_sweep/test_sweep_utils.py"
    "tests/pytest_tests/system_tests/test_sweep/test_wandb_agent_full.py"
    "tests/pytest_tests/system_tests/test_sweep/test_wandb_agent.py"
    "tests/pytest_tests/system_tests/test_sweep/test_wandb_sweep.py"
    "tests/pytest_tests/system_tests/test_system_metrics/test_open_metrics.py"
    "tests/pytest_tests/system_tests/test_launch/test_github_reference.py"
    "tests/pytest_tests/system_tests/test_launch/test_job.py"
    "tests/pytest_tests/system_tests/test_launch/test_launch_add.py"
    "tests/pytest_tests/system_tests/test_launch/test_launch_cli.py"
    "tests/pytest_tests/system_tests/test_launch/test_launch_kubernetes.py"
    "tests/pytest_tests/system_tests/test_launch/test_launch_local_container.py"
    "tests/pytest_tests/system_tests/test_launch/test_launch_run.py"
    "tests/pytest_tests/system_tests/test_launch/test_launch_sagemaker.py"
    "tests/pytest_tests/system_tests/test_launch/test_launch_sweep_cli.py"
    "tests/pytest_tests/system_tests/test_launch/test_launch_sweep.py"
    "tests/pytest_tests/system_tests/test_launch/test_launch.py"
    "tests/pytest_tests/system_tests/test_launch/test_wandb_reference.py"
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    # Tries to access /homeless-shelter
    "tests/pytest_tests/unit_tests/test_tables.py"

    # E       AssertionError: assert 'Cannot use both --async and --queue with wandb launch' in 'wandb: ERROR Find detailed error logs at: /build/source/wandb/debug-cli.nixbld.log\nError: The wandb service process exited with 1. Ensure that `sys.executable` is a valid python interpreter. You can override it with the `_executable` setting or with the `WANDB__EXECUTABLE` environment variable.\n'
    # E        +  where 'wandb: ERROR Find detailed error logs at: /build/source/wandb/debug-cli.nixbld.log\nError: The wandb service process exited with 1. Ensure that `sys.executable` is a valid python interpreter. You can override it with the `_executable` setting or with the `WANDB__EXECUTABLE` environment variable.\n' = <Result SystemExit(1)>.output
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_jobs.py"

    # Requires google-cloud-aiplatform which is not packaged as of 2023-04-25.
<<<<<<< HEAD
    "tests/pytest_tests/unit_tests/test_launch/test_runner/test_vertex.py"
=======
    "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_gcp.py"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    # Requires google-cloud-artifact-registry which is not packaged as of 2023-04-25.
    "tests/pytest_tests/unit_tests_old/tests_launch/test_kaniko_build.py"
    "tests/pytest_tests/unit_tests/test_launch/test_registry/test_gcp_artifact_registry.py"

    # Requires kfp which is not packaged as of 2023-04-25.
    "tests/pytest_tests/system_tests/test_core/test_kfp.py"

    # Requires metaflow which is not packaged as of 2023-04-25.
    "tests/pytest_tests/unit_tests/test_metaflow.py"

<<<<<<< HEAD
    # Requires tensorflow which is broken as of 2023-09-03
    "tests/pytest_tests/unit_tests/test_keras.py"

    # Try to get hardware information, not possible in the nix build environment
    "tests/pytest_tests/unit_tests/test_system_metrics/test_disk.py"

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # See https://github.com/wandb/wandb/issues/5423
    "tests/pytest_tests/unit_tests/test_docker.py"
    "tests/pytest_tests/unit_tests/test_library_public.py"
  ] ++ lib.optionals stdenv.isLinux [
    # Same as above
    "tests/pytest_tests/unit_tests/test_artifacts/test_storage.py"
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isDarwin [
=======
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # Same as above
    "tests/pytest_tests/unit_tests/test_lib/test_filesystem.py"
  ];

<<<<<<< HEAD
  disabledTests = [
    # Timing sensitive
    "test_login_timeout"
  ] ++ lib.optionals stdenv.isDarwin [
    # Disable test that fails on darwin due to issue with python3Packages.psutil:
    # https://github.com/giampaolo/psutil/issues/1219
=======
  # Disable test that fails on darwin due to issue with python3Packages.psutil:
  # https://github.com/giampaolo/psutil/issues/1219
  disabledTests = lib.optionals stdenv.isDarwin [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
