{
  absl-py,
  buildPythonPackage,
  chex,
  dm-env,
  dm-tree,
  fetchFromGitHub,
  flax,
  immutabledict,
  jax,
  lib,
  matplotlib,
  mediapy,
  numpy,
  pillow,
  pytestCheckHook,
  setuptools,
  tensorflow,
  tqdm,
}:

buildPythonPackage {
  pname = "waymax";
  version = "0-unstable-2024-03-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "waymo-research";
    repo = "waymax";
    rev = "720f9214a9bf79b3da7926497f0cd0468ca3e630";
    hash = "sha256-B1Rp5MATbEelp6G6K2wwV83QpINhOHgvAxb3mBN52Eg=";
  };

  # AttributeError: jax.tree_map was removed in JAX v0.6.0: use jax.tree.map (jax v0.4.25 or newer) or jax.tree_util.tree_map (any JAX version).
  # https://github.com/waymo-research/waymax/pull/77
  postPatch = ''
    substituteInPlace \
      waymax/agents/expert.py \
      waymax/agents/waypoint_following_agent.py \
      waymax/agents/waypoint_following_agent_test.py \
      waymax/dynamics/abstract_dynamics_test.py \
      waymax/dynamics/state_dynamics_test.py \
      waymax/env/base_environment_test.py \
      waymax/env/rollout_test.py \
      waymax/env/wrappers/brax_wrapper_test.py \
      --replace-fail "jax.tree_map" "jax.tree_util.tree_map"
  '';

  build-system = [ setuptools ];

  dependencies = [
    absl-py
    chex
    dm-env
    dm-tree
    flax
    immutabledict
    jax
    matplotlib
    mediapy
    numpy
    pillow
    tensorflow
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "waymax" ];

  disabledTestPaths = [
    # Disable visualization tests that require a GUI
    # waymax/visualization/viz_test.py Fatal Python error: Aborted
    "waymax/visualization/viz_test.py"
  ];

  meta = {
    description = "A JAX-based simulator for autonomous driving research";
    homepage = "https://github.com/waymo-research/waymax";
    changelog = "https://github.com/waymo-research/waymax/blob/main/CHANGELOG.md";
    maintainers = with lib.maintainers; [ samuela ];
  };
}
