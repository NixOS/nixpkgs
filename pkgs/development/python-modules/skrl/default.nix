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
  hypothesis,
  jax,
  mujoco,
  optax,
  pettingzoo,
  pygame,
  pymunk,
  pytest-xdist,
  pytestCheckHook,
  warp-lang,
  warp-nn,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "skrl";
  version = "2.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Toni-SM";
    repo = "skrl";
    tag = finalAttrs.version;
    hash = "sha256-pntQ/7kefi7LLLG1DTKY9Zjlzb0UXiduQCzlX5PkZds=";
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
    hypothesis
    jax
    mujoco
    optax
    pettingzoo
    pygame
    pymunk
    pytest-xdist
    pytestCheckHook
    warp-lang
    warp-nn
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Flaky when using pytest-xdist
    "test_agent"

    # TypeError: The array passed to from_dlpack must have __dlpack__ and __dlpack_device__ methods
    "test_env"
    "test_multi_agent_env"

    # OverflowError
    "test_key"

    # Require GPU access
    "test_device[cuda]"
    "test_parse_device[cuda]"
  ];

  disabledTestPaths = [
    # TypeError: Can't instantiate abstract class Memory without an implementation for abstract method 'sample'
    "tests/memories/torch/test_base.py"
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
