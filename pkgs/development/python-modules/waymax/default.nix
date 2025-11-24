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
  version = "0-unstable-2025-05-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "waymo-research";
    repo = "waymax";
    rev = "48b33d71aac20a22db7d25f2d3220596899d944a";
    hash = "sha256-YV0KI0UrFXO3HvKjqJE+K+hJJuYI4GiIR4l1fZNnl/E=";
  };

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

  disabledTests = [
    # AssertionError: Not equal to tolerance rtol=1e-07, atol=0
    "test_obs_from_state_for_different_coordinate_system0"
    "test_obs_from_state_for_different_coordinate_system1"
  ];

  disabledTestPaths = [
    # Disable visualization tests that require a GUI
    # waymax/visualization/viz_test.py Fatal Python error: Aborted
    "waymax/visualization/viz_test.py"
  ];

  meta = {
    description = "JAX-based simulator for autonomous driving research";
    homepage = "https://github.com/waymo-research/waymax";
    changelog = "https://github.com/waymo-research/waymax/blob/main/CHANGELOG.md";
    maintainers = with lib.maintainers; [ samuela ];
  };
}
