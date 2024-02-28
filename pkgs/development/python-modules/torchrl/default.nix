{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, ninja
, setuptools
, wheel
, which
, cloudpickle
, numpy
, torch
, ale-py
, gym
, pygame
, gymnasium
, mujoco
, moviepy
, git
, hydra-core
, tensorboard
, tqdm
, wandb
, packaging
, tensordict
, imageio
, pytest-rerunfailures
, pytestCheckHook
, pyyaml
, scipy
}:

buildPythonPackage rec {
  pname = "torchrl";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "rl";
    rev = "refs/tags/v${version}";
    hash = "sha256-ngl/gbNm+62W6UFNo8GOhSaIuK9FERDxGBCr++7B4gw=";
  };

  nativeBuildInputs = [
    ninja
    setuptools
    wheel
    which
  ];

  propagatedBuildInputs = [
    cloudpickle
    numpy
    packaging
    tensordict
    torch
  ];

  passthru.optional-dependencies = {
    atari = [
      ale-py
      gym
      pygame
    ];
    gym-continuous = [
      gymnasium
      mujoco
    ];
    rendering = [
      moviepy
    ];
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

  pythonImportsCheck = [
    "torchrl"
  ];

  # We have to delete the source because otherwise it is used instead of the installed package.
  preCheck = ''
    rm -rf torchrl

    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  nativeCheckInputs = [
    gymnasium
    imageio
    pytest-rerunfailures
    pytestCheckHook
    pyyaml
    scipy
  ]
  ++ passthru.optional-dependencies.atari
  ++ passthru.optional-dependencies.gym-continuous
  ++ passthru.optional-dependencies.rendering;

  disabledTests = [
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
  ];

  meta = with lib; {
    description = "A modular, primitive-first, python-first PyTorch library for Reinforcement Learning";
    homepage = "https://github.com/pytorch/rl";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
