{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  numpy,
  pybind11,
  setuptools,
  torch,

  # dependencies
  cloudpickle,
  packaging,
  pyvers,
  tensordict,

  # optional-dependencies
  # atari
  gymnasium,
  # brax
  brax,
  jax,
  # checkpointing
  torchsnapshot,
  # dm-control
  dm-control,
  # gym-continuous
  mujoco,
  # llm
  accelerate,
  datasets,
  einops,
  immutabledict,
  langdetect,
  nltk,
  playwright,
  protobuf,
  safetensors,
  sentencepiece,
  transformers,
  vllm,
  # marl
  pettingzoo,
  # offline-data
  h5py,
  huggingface-hub,
  minari,
  pandas,
  pillow,
  requests,
  scikit-learn,
  torchvision,
  tqdm,
  # rendering
  moviepy,
  # utils
  git,
  hydra-core,
  tensorboard,
  wandb,

  # tests
  imageio,
  pytest-rerunfailures,
  pytestCheckHook,
  pyyaml,
  scipy,
}:

buildPythonPackage rec {
  pname = "torchrl";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "rl";
    tag = "v${version}";
    hash = "sha256-Vd/w11P4NVrx2xki+VYlXQaM8F+vpdokke8ZAHg6h0Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pybind11[global]" "pybind11"
  '';

  build-system = [
    cmake
    ninja
    numpy
    pybind11
    setuptools
    torch
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    cloudpickle
    numpy
    packaging
    tensordict
    pyvers
    torch
  ];

  optional-dependencies = {
    atari = [
      gymnasium
    ]
    ++ gymnasium.optional-dependencies.atari;
    brax = [
      brax
      jax
    ];
    checkpointing = [ torchsnapshot ];
    dm-control = [ dm-control ];
    gym-continuous = [
      gymnasium
      mujoco
    ];
    llm = [
      accelerate
      datasets
      einops
      immutabledict
      langdetect
      nltk
      playwright
      protobuf
      safetensors
      sentencepiece
      transformers
      vllm
    ];
    marl = [
      # dm-meltingpot (unpackaged)
      pettingzoo
      # vmas (unpackaged)
    ];
    offline-data = [
      h5py
      huggingface-hub
      minari
      pandas
      pillow
      requests
      scikit-learn
      torchvision
      tqdm
    ];
    open-spiel = [
      # open-spiel (unpackaged)
    ];
    rendering = [ moviepy ];
    replay-buffer = [ torch ];
    utils = [
      git
      hydra-core
      # hydra-submitit-launcher (unpackaged)
      tensorboard
      tqdm
      wandb
    ];
  };

  # torchrl needs to create a folder to store datasets
  preBuild = ''
    export D4RL_DATASET_DIR=$(mktemp -d)
  '';

  pythonImportsCheck = [ "torchrl" ];

  # We have to delete the source because otherwise it is used instead of the installed package.
  preCheck = ''
    rm -rf torchrl

    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  nativeCheckInputs = [
    h5py
    gymnasium
    imageio
    pytest-rerunfailures
    pytestCheckHook
    pyyaml
    scipy
    torchvision
  ]
  ++ optional-dependencies.atari
  ++ optional-dependencies.gym-continuous
  ++ optional-dependencies.llm
  ++ optional-dependencies.rendering;

  disabledTests = [
    # Require network
    "test_create_or_load_dataset"
    "test_from_text_env_tokenizer"
    "test_from_text_env_tokenizer_catframes"
    "test_from_text_rb_slicesampler"
    "test_generate"
    "test_get_dataloader"
    "test_get_scores"
    "test_preproc_data"
    "test_prompt_tensordict_tokenizer"
    "test_reward_model"
    "test_tensordict_tokenizer"
    "test_transform_compose"
    "test_transform_model"
    "test_transform_no_env"
    "test_transform_rb"

    # ray.exceptions.RuntimeEnvSetupError: Failed to set up runtime environment
    "TestRayCollector"

    # torchrl is incompatible with gymnasium>=1.0
    # https://github.com/pytorch/rl/discussions/2483
    "test_resetting_strategies"
    "test_torchrl_to_gym"
    "test_vecenvs_nan"

    # gym.error.VersionNotFound: Environment version `v5` for environment `HalfCheetah` doesn't exist.
    "test_collector_run"
    "test_transform_inverse"

    # OSError: Unable to synchronously create file (unable to truncate a file which is already open)
    "test_multi_env"
    "test_simple_env"

    # ImportWarning: Ignoring non-library in plugin directory:
    # /nix/store/cy8vwf1dacp3xfwnp9v6a1sz8bic8ylx-python3.12-mujoco-3.3.2/lib/python3.12/site-packages/mujoco/plugin/libmujoco.so.3.3.2
    "test_auto_register"
    "test_info_dict_reader"

    # mujoco.FatalError: an OpenGL platform library has not been loaded into this process, this most likely means that a valid OpenGL context has not been created before mjr_makeContext was called
    "test_vecenvs_env"

    # ValueError: Can't write images with one color channel.
    "test_log_video"

    # Those tests require the ALE environments (provided by unpackaged shimmy)
    "test_collector_env_reset"
    "test_gym"
    "test_gym_fake_td"
    "test_recorder"
    "test_recorder_load"
    "test_rollout"
    "test_parallel_trans_env_check"
    "test_serial_trans_env_check"
    "test_single_trans_env_check"
    "test_td_creation_from_spec"
    "test_trans_parallel_env_check"
    "test_trans_serial_env_check"
    "test_transform_env"

    # undeterministic
    "test_distributed_collector_updatepolicy"
    "test_timeit"

    # On a 24 threads system
    # assert torch.get_num_threads() == max(1, init_threads - 3)
    # AssertionError: assert 23 == 21
    "test_auto_num_threads"

    # Flaky (hangs indefinitely on some CPUs)
    "test_gae_multidim"
    "test_gae_param_as_tensor"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Flaky
    # AssertionError: assert tensor([51.]) == ((5 * 11) + 2)
    "test_vecnorm_parallel_auto"
  ];

  disabledTestPaths = [
    # ERROR collecting test/smoke_test.py
    # import file mismatch:
    # imported module 'smoke_test' has this __file__ attribute:
    #   /build/source/test/llm/smoke_test.py
    # which is not the same as the test file we want to collect:
    #   /build/source/test/smoke_test.py
    "test/llm"
  ];

  meta = {
    description = "Modular, primitive-first, python-first PyTorch library for Reinforcement Learning";
    homepage = "https://github.com/pytorch/rl";
    changelog = "https://github.com/pytorch/rl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
