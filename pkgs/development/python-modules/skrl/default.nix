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

  # Fix Jax 0.10.0 compatibility
  # TypeError: clip() got an unexpected keyword argument 'a_min'
  postPatch = ''
    substituteInPlace skrl/models/jax/gaussian.py \
      --replace-fail \
        "jnp.clip(log_std, a_min=log_std_min, a_max=log_std_max)" \
        "jnp.clip(log_std, min=log_std_min, max=log_std_max)" \
      --replace-fail \
        "jnp.clip(actions, a_min=clip_actions_min, a_max=clip_actions_max)" \
        "jnp.clip(actions, min=clip_actions_min, max=clip_actions_max)"

    substituteInPlace skrl/models/jax/deterministic.py \
      --replace-fail \
        "jnp.clip(actions, a_min=self._d_clip_actions_min, a_max=self._d_clip_actions_max)" \
        "jnp.clip(actions, min=self._d_clip_actions_min, max=self._d_clip_actions_max)"
  '';

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
