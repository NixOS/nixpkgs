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

buildPythonPackage rec {
  pname = "waymax";
  version = "0-unstable-2025-03-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "waymo-research";
    repo = "waymax";
    rev = "720f9214a9bf79b3da7926497f0cd0468ca3e630";
    hash = "sha256-B1Rp5MATbEelp6G6K2wwV83QpINhOHgvAxb3mBN52Eg=";
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
