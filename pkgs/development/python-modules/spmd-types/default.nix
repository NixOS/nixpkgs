{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  torch,

  # tests
  expecttest,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "spmd-types";
  version = "0.2.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "spmd_types";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5N3EcZu9MsQM9Gzow+zt9GY89zd10Y8mpAgS/agGdpM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        'version = "0.2.0"' \
        'version = "${finalAttrs.version}"'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    # Not listed in dependencies, but required for `spmd_types` at import time
    # https://github.com/meta-pytorch/spmd_types/blob/v0.2.5/spmd_types/_collectives.py#L13
    torch
  ];

  pythonImportsCheck = [ "spmd_types" ];

  nativeCheckInputs = [
    expecttest
    numpy
    pytestCheckHook
  ];

  disabledTests = [
    # Require internet access
    "test_github_ci"

    # SpmdTypeError not raised (type checking issues with raw distributed collectives)
    "test_all_gather_into_tensor_wrong_input_context"
    "test_factory_raw_collective_raises"
    "test_raw_all_gather_into_tensor_v_to_i"
    "test_raw_all_gather_into_tensor_wrong_input_type"
    "test_raw_all_gather_into_tensor_wrong_output_type"
    "test_raw_reduce_scatter_tensor_p_to_v"
    "test_raw_reduce_scatter_tensor_wrong_input_type"
    "test_strict_unknown_group_input_raises"
    "test_strict_unknown_group_output_raises"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [

    # Error message mismatch:
    #   Expected: "'function' object does not support the context manager protocol"
    #   Actual: "'function' object does not support the context manager protocol (missed __exit__ method)"
    "test_context_form_rejects_types"
  ];

  meta = {
    description = "Type system for distributed training code, based off of JAX's sharding in types, but adapted for the PyTorch ecosystem";
    homepage = "https://github.com/meta-pytorch/spmd_types";
    changelog = "https://github.com/meta-pytorch/spmd_types/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
