{
  lib,
  stdenv,
  apple-sdk_11,
  fetchFromGitHub,

  ## wandb-core
  buildGoModule,
  git,
  versionCheckHook,

  ## gpu-stats
  rustPlatform,
  darwin,

  ## wandb
  buildPythonPackage,
  substituteAll,

  # build-system
  hatchling,

  # dependencies
  click,
  docker-pycreds,
  gitpython,
  platformdirs,
  protobuf,
  psutil,
  pyyaml,
  requests,
  sentry-sdk_2,
  setproctitle,
  setuptools,
  pythonOlder,
  typing-extensions,

  # tests
  pytestCheckHook,
  azure-core,
  azure-containerregistry,
  azure-identity,
  azure-storage-blob,
  bokeh,
  boto3,
  coverage,
  flask,
  google-cloud-artifact-registry,
  google-cloud-compute,
  google-cloud-storage,
  hypothesis,
  jsonschema,
  kubernetes,
  kubernetes-asyncio,
  matplotlib,
  moviepy,
  pandas,
  parameterized,
  pillow,
  plotly,
  pydantic,
  pyfakefs,
  pyte,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytest-timeout,
  pytest-xdist,
  rdkit,
  responses,
  scikit-learn,
  soundfile,
  tenacity,
  torch,
  tqdm,
}:

let
  version = "0.18.5";
  src = fetchFromGitHub {
    owner = "wandb";
    repo = "wandb";
    rev = "refs/tags/v${version}";
    hash = "sha256-nx50baneYSSIWPAIOkUk4cGCNpWAhv7IwFDQJ4vUMiw=";
  };

  gpu-stats = rustPlatform.buildRustPackage rec {
    pname = "gpu-stats";
    version = "0.2.0";
    inherit src;

    sourceRoot = "${src.name}/gpu_stats";

    cargoHash = "sha256-4udGG4I2Hr8r84c4WX6QGG/+bcHK4csXqwddvIiKmkw=";

    buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.IOKit
    ];

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgram = "${placeholder "out"}/bin/gpu_stats";
    versionCheckProgramArg = [ "--version" ];
    doInstallCheck = true;

    meta = {
      mainProgram = "gpu_stats";
      # ld: library not found for -lIOReport
      # TODO: succeeds on https://github.com/NixOS/nixpkgs/pull/348827, so try again once it lands on master
      broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
    };
  };

  wandb-core = buildGoModule rec {
    pname = "wandb-core";
    inherit src version;

    sourceRoot = "${src.name}/core";

    # hardcode the `gpu_stats` binary path.
    postPatch = ''
      substituteInPlace pkg/monitor/gpu.go \
        --replace-fail \
          'cmdPath, err := getGPUStatsCmdPath()' \
          'cmdPath, err := "${lib.getExe gpu-stats}", error(nil)'
    '';

    vendorHash = null;

    nativeBuildInputs = [
      git
    ];

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgramArg = [ "--version" ];
    doInstallCheck = true;

    __darwinAllowLocalNetworking = true;

    meta.mainProgram = "wandb-core";
  };
in

buildPythonPackage rec {
  pname = "wandb";
  pyproject = true;

  inherit src version;

  patches = [
    # Replace git paths
    (substituteAll {
      src = ./hardcode-git-path.patch;
      git = lib.getExe git;
    })
  ];

  # Hard-code the path to the `wandb-core` binary in the code.
  postPatch = ''
    substituteInPlace wandb/util.py \
      --replace-fail \
        'bin_path = pathlib.Path(__file__).parent / "bin" / "wandb-core"' \
        'bin_path = pathlib.Path("${lib.getExe wandb-core}")'
  '';

  env = {
    # Prevent the install script to try building and embedding the `gpu_stats` and `wandb-core`
    # binaries in the wheel.
    # Their path have been patched accordingly in the `wandb-core` and `wanbd` source codes.
    # https://github.com/wandb/wandb/blob/v0.18.5/hatch_build.py#L37-L47
    WANDB_BUILD_SKIP_GPU_STATS = true;
    WANDB_BUILD_UNIVERSAL = true;
  };

  build-system = [
    hatchling
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11;

  dependencies =
    [
      click
      docker-pycreds
      gitpython
      platformdirs
      protobuf
      psutil
      pyyaml
      requests
      sentry-sdk_2
      setproctitle
      # setuptools is necessary since pkg_resources is required at runtime.
      setuptools
    ]
    ++ lib.optionals (pythonOlder "3.12") [
      typing-extensions
    ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    azure-core
    azure-containerregistry
    azure-identity
    azure-storage-blob
    boto3
    bokeh
    coverage
    flask
    google-cloud-artifact-registry
    google-cloud-compute
    google-cloud-storage
    hypothesis
    jsonschema
    kubernetes
    kubernetes-asyncio
    matplotlib
    moviepy
    pandas
    parameterized
    pillow
    plotly
    pydantic
    pyfakefs
    pyte
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytest-timeout
    pytest-xdist
    rdkit
    responses
    scikit-learn
    soundfile
    tenacity
    torch
    tqdm
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # Require docker access
    "tests/release_tests/test_launch"
    "tests/system_tests"
  ];

  disabledTests =
    [
      # Probably failing because of lack of internet access
      # AttributeError: module 'wandb.sdk.launch.registry' has no attribute 'azure_container_registry'. Did you mean: 'elastic_container_registry'?
      "test_registry_from_uri"

      # Require docker
      "test_get_requirements_section_pyproject"
      "test_local_custom_env"
      "test_local_custom_port"
      "test_local_default"

      # Expects python binary to be named `python3` but nix provides `python3.12`
      # AssertionError: assert ['python3.12', 'main.py'] == ['python3', 'main.py']
      "test_get_entrypoint"

      # Require internet access
      "test_audio_refs"
      "test_bind_image"
      "test_check_cors_configuration"
      "test_check_wandb_version"
      "test_from_path_project_type"
      "test_image_accepts_bounding_boxes"
      "test_image_accepts_bounding_boxes_optional_args"
      "test_image_accepts_masks"
      "test_image_accepts_masks_without_class_labels"
      "test_image_seq_to_json"
      "test_max_images"
      "test_media_keys_escaped_as_glob_for_publish"
      "test_parse_path"
      "test_parse_project_path"
      "test_translates_azure_err_to_normal_err"

      # tests assertion if filesystem is compressed
      "test_artifact_file_cache_cleanup"

      # Tries to access a storage disk but there are none in the sandbox
      # psutil.test_disk_out() returns None
      "test_disk_in"
      "test_disk_out"

      # AssertionError: assert is_available('http://localhost:9400/metrics')
      "test_dcgm"

      # Error in the moviepy package:
      # TypeError: must be real number, not NoneType
      "test_video_numpy_mp4"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      # AssertionError: assert not copy2_mock.called
      "test_copy_or_overwrite_changed_no_copy"

      # Fatal Python error: Aborted
      "test_convert_plots"
      "test_gpu_apple"
      "test_image_from_matplotlib_with_image"
      "test_make_plot_media_from_matplotlib_with_image"
      "test_make_plot_media_from_matplotlib_without_image"
      "test_matplotlib_contains_images"
      "test_matplotlib_image"
      "test_matplotlib_plotly_with_multiple_axes"
      "test_matplotlib_to_plotly"
      "test_plotly_from_matplotlib_with_image"
    ];

  pythonImportsCheck = [ "wandb" ];

  meta = {
    description = "CLI and library for interacting with the Weights and Biases API";
    homepage = "https://github.com/wandb/wandb";
    changelog = "https://github.com/wandb/wandb/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ samuela ];
    broken = gpu-stats.meta.broken || wandb-core.meta.broken;
  };
}
