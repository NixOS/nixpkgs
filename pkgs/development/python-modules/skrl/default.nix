{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  gym,
  gymnasium,
  packaging,
  tensorboard,
  torch,
  tqdm,
  wandb,

  # tests
  flax,
  jax,
  optax,
  pettingzoo,
  pygame,
  pymunk,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "skrl";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Toni-SM";
    repo = "skrl";
    tag = finalAttrs.version;
    hash = "sha256-5lkoYAmMIWqK3+E3WxXMWS9zal2DhZkfl30EkrHKpdI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gym
    gymnasium
    packaging
    tensorboard
    torch
    tqdm
    wandb
  ];

  pythonImportsCheck = [ "skrl" ];

  nativeCheckInputs = [
    flax
    jax
    optax
    pettingzoo
    pygame
    pymunk
    pytestCheckHook
  ];

  disabledTests = [
    # TypeError: The array passed to from_dlpack must have __dlpack__ and __dlpack_device__ methods
    "test_env"
    "test_multi_agent_env"

    # OverflowError
    "test_key"
  ];

  meta = {
    description = "Reinforcement learning library using PyTorch focusing on readability and simplicity";
    homepage = "https://skrl.readthedocs.io";
    downloadPage = "https://github.com/Toni-SM/skrl";
    changelog = "https://github.com/Toni-SM/skrl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
