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
  version = "1.0.29";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "pytorch-image-models";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kmz6olMnxeD5MMiJnz3mcdz6RYO7T8kaP2+mJI2RAco=";
  };

  # Fix torch 2.11.0 compatibility
  # AttributeError: 'AdamWLegacy' object has no attribute '_cuda_graph_capture_health_check'
  postPatch = ''
    substituteInPlace \
      timm/optim/adopt.py \
      timm/optim/adamw.py \
      timm/optim/nadamw.py \
      --replace-fail \
        "_cuda_graph_capture_health_check" \
        "_accelerator_graph_capture_health_check"
  '';

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
    lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # assert nan < 71.5658950805664
      "test_optim_factory"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # AssertionError: assert 98178776.0 < 115.88214111328125
      "test_optim_factory"
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
