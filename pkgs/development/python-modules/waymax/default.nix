{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  chex,
  dm-env,
  dm-tree,
  flax,
  immutabledict,
  jax,
  matplotlib,
  mediapy,
  numpy,
  pillow,
  tensorflow,
  tqdm,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "waymo-waymax";
  version = "0.1.0-unstable-2025-10-23";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "waymo-research";
    repo = "waymax";
    rev = "a64dfec9be8576b60d9cecc94f406d9812d4a7d0";
    hash = "sha256-vS0ZxLPKcjRzu5QaFApOVYNO5LBNQjop8wzmdEVdMC8=";
  };

  # jax>=0.12 no longer supports 2D vectors in jnp.cross
  # ValueError: Dimension must be 3 for cross product
  postPatch = ''
    substituteInPlace waymax/metrics/roadgraph.py \
      --replace-fail \
        "jnp.cross(points_to_edge, nearest_vector_xys)" \
        "(points_to_edge[..., 0] * nearest_vector_xys[..., 1] - points_to_edge[..., 1] * nearest_vector_xys[..., 0])" \
      --replace-fail \
        "jnp.cross(points_to_edge, prior_vector_xys)" \
        "(points_to_edge[..., 0] * prior_vector_xys[..., 1] - points_to_edge[..., 1] * prior_vector_xys[..., 0])"
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

  pythonImportsCheck = [ "waymax" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Fatal Python error: Aborted (requires a GUI)
    "waymax/visualization/viz_test.py"
  ];

  meta = {
    description = "JAX-based simulator for autonomous driving research";
    homepage = "https://github.com/waymo-research/waymax";
    changelog = "https://github.com/waymo-research/waymax/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ samuela ];
  };
})
