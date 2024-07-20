{
  lib,
  stdenv,
  appdirs,
  azure-containerregistry,
  azure-core,
  azure-identity,
  azure-storage-blob,
  bokeh,
  boto3,
  buildPythonPackage,
  click,
  docker-pycreds,
  fetchFromGitHub,
  flask,
  git,
  gitpython,
  google-cloud-artifact-registry,
  google-cloud-compute,
  google-cloud-storage,
  hypothesis,
  imageio,
  jsonref,
  jsonschema,
  keras,
  kubernetes,
  matplotlib,
  mlflow,
  moviepy,
  nbclient,
  nbformat,
  pandas,
  parameterized,
  pathtools,
  protobuf,
  psutil,
  pydantic,
  pyfakefs,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  responses,
  scikit-learn,
  sentry-sdk,
  setproctitle,
  setuptools,
  soundfile,
  substituteAll,
  torch,
  tqdm,
}:

buildPythonPackage rec {
  pname = "wandb";
  version = "0.16.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XXs9KjiAPzZ932r4UJ87RpM+qhg/bNDWEYsq2Ua6SRw=";
  };

  patches = [
    # Replace git paths
    (substituteAll {
      src = ./hardcode-git-path.patch;
      git = "${lib.getBin git}/bin/git";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  # setuptools is necessary since pkg_resources is required at runtime.
  propagatedBuildInputs = [
    appdirs
    click
    docker-pycreds
    gitpython
    pathtools
    protobuf
    psutil
    pyyaml
    requests
    sentry-sdk
    setproctitle
    setuptools
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
    google-cloud-compute
    google-cloud-storage
    hypothesis
    imageio
    jsonref
    jsonschema
    keras
    kubernetes
    matplotlib
    mlflow
    moviepy
    nbclient
    nbformat
    pandas
    parameterized
    pydantic
    pyfakefs
    pytest-mock
    pytest-xdist
    pytestCheckHook
    responses
    scikit-learn
    soundfile
    torch
    tqdm
  ];

  # Set BOKEH_CDN_VERSION to stop bokeh throwing an exception in tests
  preCheck = ''
    export HOME=$(mktemp -d)
    export BOKEH_CDN_VERSION=${bokeh.version}
  '';

  pythonRelaxDeps = [ "protobuf" ];

  pytestFlagsArray = [
    # We want to run only unit tests
    "tests/pytest_tests"
  ];

  disabledTestPaths =
    [
      # Tests that try to get chatty over sockets or spin up servers, not possible in the nix build environment.
      "tests/pytest_tests/system_tests/test_notebooks/test_notebooks.py"
      "tests/pytest_tests/unit_tests_old/test_cli.py"
      "tests/pytest_tests/unit_tests_old/test_data_types.py"
      "tests/pytest_tests/unit_tests_old/test_file_stream.py"
      "tests/pytest_tests/unit_tests_old/test_file_upload.py"
      "tests/pytest_tests/unit_tests_old/test_footer.py"
      "tests/pytest_tests/unit_tests_old/test_internal_api.py"
      "tests/pytest_tests/unit_tests_old/test_metric_internal.py"
      "tests/pytest_tests/unit_tests_old/test_public_api.py"
      "tests/pytest_tests/unit_tests_old/test_runtime.py"
      "tests/pytest_tests/unit_tests_old/test_sender.py"
      "tests/pytest_tests/unit_tests_old/test_summary.py"
      "tests/pytest_tests/unit_tests_old/test_tb_watcher.py"
      "tests/pytest_tests/unit_tests_old/test_time_resolution.py"
      "tests/pytest_tests/unit_tests_old/test_wandb_agent.py"
      "tests/pytest_tests/unit_tests_old/test_wandb_integration.py"
      "tests/pytest_tests/unit_tests_old/test_wandb_run.py"
      "tests/pytest_tests/unit_tests_old/test_wandb.py"
      "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_aws.py"
      "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_cli.py"
      "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_docker.py"
      "tests/pytest_tests/unit_tests_old/tests_launch/test_launch.py"
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
      "tests/pytest_tests/system_tests/test_artifacts/test_misc.py"
      "tests/pytest_tests/system_tests/test_artifacts/test_misc2.py"
      "tests/pytest_tests/system_tests/test_artifacts/test_object_references.py"
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
      "tests/pytest_tests/system_tests/test_core/test_save_policies.py"
      "tests/pytest_tests/system_tests/test_core/test_sender.py"
      "tests/pytest_tests/system_tests/test_core/test_start_method.py"
      "tests/pytest_tests/system_tests/test_core/test_system_info.py"
      "tests/pytest_tests/system_tests/test_core/test_tb_watcher.py"
      "tests/pytest_tests/system_tests/test_core/test_telemetry_full.py"
      "tests/pytest_tests/system_tests/test_core/test_time_resolution.py"
      "tests/pytest_tests/system_tests/test_core/test_torch_full.py"
      "tests/pytest_tests/system_tests/test_core/test_validation_data_logger.py"
      "tests/pytest_tests/system_tests/test_core/test_wandb_init.py"
      "tests/pytest_tests/system_tests/test_core/test_wandb_integration.py"
      "tests/pytest_tests/system_tests/test_core/test_wandb_run.py"
      "tests/pytest_tests/system_tests/test_core/test_wandb_settings.py"
      "tests/pytest_tests/system_tests/test_core/test_wandb_tensorflow.py"
      "tests/pytest_tests/system_tests/test_core/test_wandb_verify.py"
      "tests/pytest_tests/system_tests/test_core/test_wandb.py"
      "tests/pytest_tests/system_tests/test_importers/test_import_mlflow.py"
      "tests/pytest_tests/system_tests/test_launch/test_github_reference.py"
      "tests/pytest_tests/system_tests/test_launch/test_job_status_tracker.py"
      "tests/pytest_tests/system_tests/test_launch/test_job.py"
      "tests/pytest_tests/system_tests/test_launch/test_launch_add.py"
      "tests/pytest_tests/system_tests/test_launch/test_launch_cli.py"
      "tests/pytest_tests/system_tests/test_launch/test_launch_kubernetes.py"
      "tests/pytest_tests/system_tests/test_launch/test_launch_local_container.py"
      "tests/pytest_tests/system_tests/test_launch/test_launch_run.py"
      "tests/pytest_tests/system_tests/test_launch/test_launch_sagemaker.py"
      "tests/pytest_tests/system_tests/test_launch/test_launch_sweep_cli.py"
      "tests/pytest_tests/system_tests/test_launch/test_launch_sweep.py"
      "tests/pytest_tests/system_tests/test_launch/test_launch_vertex.py"
      "tests/pytest_tests/system_tests/test_launch/test_launch.py"
      "tests/pytest_tests/system_tests/test_launch/test_wandb_reference.py"
      "tests/pytest_tests/system_tests/test_nexus/test_nexus.py"
      "tests/pytest_tests/system_tests/test_sweep/test_public_api.py"
      "tests/pytest_tests/system_tests/test_sweep/test_sweep_scheduler.py"
      "tests/pytest_tests/system_tests/test_sweep/test_sweep_utils.py"
      "tests/pytest_tests/system_tests/test_sweep/test_wandb_agent_full.py"
      "tests/pytest_tests/system_tests/test_sweep/test_wandb_agent.py"
      "tests/pytest_tests/system_tests/test_sweep/test_wandb_sweep.py"
      "tests/pytest_tests/system_tests/test_system_metrics/test_open_metrics.py"
      "tests/pytest_tests/system_tests/test_system_metrics/test_system_monitor.py"

      # Tries to access /homeless-shelter
      "tests/pytest_tests/unit_tests/test_tables.py"

      # E       AssertionError: assert 'Cannot use both --async and --queue with wandb launch' in 'wandb: ERROR Find detailed error logs at: /build/source/wandb/debug-cli.nixbld.log\nError: The wandb service process exited with 1. Ensure that `sys.executable` is a valid python interpreter. You can override it with the `_executable` setting or with the `WANDB__EXECUTABLE` environment variable.\n'
      # E        +  where 'wandb: ERROR Find detailed error logs at: /build/source/wandb/debug-cli.nixbld.log\nError: The wandb service process exited with 1. Ensure that `sys.executable` is a valid python interpreter. You can override it with the `_executable` setting or with the `WANDB__EXECUTABLE` environment variable.\n' = <Result SystemExit(1)>.output
      "tests/pytest_tests/unit_tests_old/tests_launch/test_launch_jobs.py"

      # Requires google-cloud-aiplatform which is not packaged as of 2023-04-25.
      "tests/pytest_tests/unit_tests/test_launch/test_runner/test_vertex.py"

      # Requires google-cloud-artifact-registry which is not packaged as of 2023-04-25.
      "tests/pytest_tests/unit_tests/test_launch/test_registry/test_gcp_artifact_registry.py"

      # Requires kfp which is not packaged as of 2023-04-25.
      "tests/pytest_tests/system_tests/test_core/test_kfp.py"

      # Requires kubernetes_asyncio which is not packaged as of 2024-01-14.
      "tests/pytest_tests/unit_tests/test_launch/test_builder/test_kaniko.py"
      "tests/pytest_tests/unit_tests/test_launch/test_runner/test_kubernetes.py"
      "tests/pytest_tests/unit_tests/test_launch/test_runner/test_safe_watch.py"

      # Requires metaflow which is not packaged as of 2023-04-25.
      "tests/pytest_tests/unit_tests/test_metaflow.py"

      # Requires tensorflow which is broken as of 2023-09-03
      "tests/pytest_tests/unit_tests/test_keras.py"

      # Try to get hardware information, not possible in the nix build environment
      "tests/pytest_tests/unit_tests/test_system_metrics/test_disk.py"

      # See https://github.com/wandb/wandb/issues/5423
      "tests/pytest_tests/unit_tests/test_docker.py"
      "tests/pytest_tests/unit_tests/test_library_public.py"

      # See https://github.com/wandb/wandb/issues/6836
      "tests/pytest_tests/unit_tests_old/test_logging.py"
    ]
    ++ lib.optionals stdenv.isLinux [
      # Same as above
      "tests/pytest_tests/unit_tests/test_artifacts/test_storage.py"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # Same as above
      "tests/pytest_tests/unit_tests/test_lib/test_filesystem.py"
    ];

  disabledTests =
    [
      # Timing sensitive
      "test_login_timeout"

      # Tensorflow 2.13 is too old for the current version of keras
      # ModuleNotFoundError: No module named 'keras.api._v2'
      "test_saved_model_keras"
      "test_sklearn_saved_model"
      "test_pytorch_saved_model"
      "test_tensorflow_keras_saved_model"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # Disable test that fails on darwin due to issue with python3Packages.psutil:
      # https://github.com/giampaolo/psutil/issues/1219
      "test_tpu_system_stats"
    ];

  pythonImportsCheck = [ "wandb" ];

  # unmaintainable list of disabled tests
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "CLI and library for interacting with the Weights and Biases API";
    homepage = "https://github.com/wandb/wandb";
    changelog = "https://github.com/wandb/wandb/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
