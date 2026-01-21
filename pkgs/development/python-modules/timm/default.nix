{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  pdm-backend,

  # dependencies
  huggingface-hub,
  pyyaml,
  safetensors,
  torch,
  torchvision,

  # tests
  expecttest,
  pytestCheckHook,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "timm";
  version = "1.0.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "pytorch-image-models";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uimOYftxX3zRvrLlT8Y23g3LdlGUDVs3AMMyKNFbsPg=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    huggingface-hub
    pyyaml
    safetensors
    torch
    torchvision
  ];

  nativeCheckInputs = [
    expecttest
    pytestCheckHook
    pytest-timeout
  ];

  enabledTestPaths = [ "tests" ];

  disabledTests =
    lib.optionals (pythonAtLeast "3.14") [
      # RuntimeError: torch.compile is not supported on Python 3.14+
      "test_kron"

      # AttributeError: 'LsePlus2d' object has no attribute '__annotations__'. Did you mean: '__annotate_func__'?
      "test_torchscript"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # torch._dynamo.exc.BackendCompilerFailed: backend='inductor' raised:
      # CppCompileError: C++ compile error
      # OpenMP support not found.
      "test_kron"
    ];

  disabledTestPaths = [
    # Takes too long and also tries to download models
    "tests/test_models.py"
  ];

  pythonImportsCheck = [
    "timm"
    "timm.data"
  ];

  meta = {
    description = "PyTorch image models, scripts, and pretrained weights";
    homepage = "https://huggingface.co/docs/timm/index";
    changelog = "https://github.com/huggingface/pytorch-image-models/blob/${finalAttrs.src.tag}/README.md#whats-new";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
