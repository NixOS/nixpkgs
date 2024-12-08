{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  ninja,
  setuptools,
  which,

  # dependencies
  cloudpickle,
  numpy,
  packaging,
  tensordict,
  torch,

  # optional-dependencies
  ale-py,
  gym,
  pygame,
  torchsnapshot,
  gymnasium,
  mujoco,
  h5py,
  huggingface-hub,
  minari,
  pandas,
  pillow,
  requests,
  scikit-learn,
  torchvision,
  tqdm,
  moviepy,
  git,
  hydra-core,
  tensorboard,
  wandb,

  # checks
  imageio,
  pytest-rerunfailures,
  pytestCheckHook,
  pyyaml,
  scipy,
}:

buildPythonPackage rec {
  pname = "torchrl";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "rl";
    rev = "refs/tags/v${version}";
    hash = "sha256-uDpOdOuHTqKFKspHOpl84kD9adEKZjvO2GnYuL27H5c=";
  };

  build-system = [
    ninja
    setuptools
    which
  ];

  dependencies = [
    cloudpickle
    numpy
    packaging
    tensordict
    torch
  ];

  optional-dependencies = {
    atari = [
      ale-py
      gym
      pygame
    ];
    checkpointing = [ torchsnapshot ];
    gym-continuous = [
      gymnasium
      mujoco
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
    rendering = [ moviepy ];
    utils = [
      git
      hydra-core
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

  nativeCheckInputs =
    [
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
    ++ optional-dependencies.rendering;

  disabledTests = [
    # torchrl is incompatible with gymnasium>=1.0
    # https://github.com/pytorch/rl/discussions/2483
    "test_resetting_strategies"
    "test_torchrl_to_gym"

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
  ];

  meta = {
    description = "Modular, primitive-first, python-first PyTorch library for Reinforcement Learning";
    homepage = "https://github.com/pytorch/rl";
    changelog = "https://github.com/pytorch/rl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
