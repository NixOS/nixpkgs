{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pandas,
  pytestCheckHook,
  setuptools,
  tensorboard,
  torch,
  torchvision,
}:
let
  version = "0.4.0";
  repo = fetchFromGitHub {
    owner = "pytorch";
    repo = "kineto";
    rev = "refs/tags/v${version}";
    hash = "sha256-nAtqGCv8q3Tati3NOGWWLb+gXdvO3qmECeC1WG2Mt3M=";
  };
in
buildPythonPackage {
  pname = "torch_tb_profiler";
  inherit version;
  pyproject = true;

  # See https://discourse.nixos.org/t/extracting-sub-directory-from-fetchgit-or-fetchurl-or-any-derivation/8830.
  src = "${repo}/tb_plugin";

  build-system = [ setuptools ];

  dependencies = [
    pandas
    tensorboard
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
    torchvision
  ];

  disabledTests = [
    # Tests that attempt to access the filesystem in naughty ways.
    "test_profiler_api_without_gpu"
    "test_tensorboard_end2end"
    "test_tensorboard_with_path_prefix"
    "test_tensorboard_with_symlinks"
    "test_autograd_api"
    "test_profiler_api_with_record_shapes_memory_stack"
    "test_profiler_api_without_record_shapes_memory_stack"
    "test_profiler_api_without_step"
  ];

  pythonImportsCheck = [ "torch_tb_profiler" ];

  meta = {
    description = "PyTorch Profiler TensorBoard Plugin";
    homepage = "https://github.com/pytorch/kineto";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
