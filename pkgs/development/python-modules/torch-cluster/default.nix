{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  torch,

  # buildInputs
  pybind11,

  # dependencies
  scipy,

  # tests
  pytestCheckHook,

  # passthru
  nix-update-script,
}:

buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "torch-cluster";
  version = "2.6.3-unstable-2026-03-26";
  pyproject = true;
  __structuredAttrs = true;

  # Last stable release is from 2023
  # Development is still active, but nothing was properly tagged on GitHub or Pypi
  # See: https://github.com/rusty1s/pytorch_cluster/issues/270
  src = fetchFromGitHub {
    owner = "rusty1s";
    repo = "pytorch_cluster";
    rev = "af7b9f0af6b74be1594eb3d0a1685470cbb21265";
    hash = "sha256-2SXkk7m+feqk7uDir3Ov31TujyIUrRSEwONaiaq3Vvs=";
  };

  build-system = [
    setuptools
    torch
  ];

  buildInputs = [
    pybind11
  ];

  dependencies = [
    scipy
  ];

  pythonImportsCheck = [ "torch_cluster" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Otherwise python imports torch_cluster from /build/source instead of $out/..., which fails when
  # trying to load the inexistant .so artifacts.
  preCheck = ''
    rm -rf torch_cluster
  '';

  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    "test_fps"
    "test_nearest"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "PyTorch Extension Library of Optimized Graph Cluster Algorithms";
    homepage = "https://github.com/rusty1s/pytorch_cluster";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
