{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  huggingface-hub,
  pyyaml,
  safetensors,
  torch,
  torchvision,

  # tests
  bash,
  expecttest,
  pytestCheckHook,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "timm";
  version = "1.0.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "pytorch-image-models";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dbBgwtD4uHxVULKtuWqiX3WQRjPg4gxGfths4tUXZLw=";
  };

  postPatch =
    # Fix torch 2.11.0 compatibility
    # AttributeError: 'AdamWLegacy' object has no attribute '_cuda_graph_capture_health_check'
    ''
      substituteInPlace \
        timm/optim/adopt.py \
        timm/optim/adamw.py \
        timm/optim/nadamw.py \
        --replace-fail \
          "_cuda_graph_capture_health_check" \
          "_accelerator_graph_capture_health_check"
    ''
    # /bin/bash does not exist in the sandbox (sweep.py is not installed, only used by tests)
    + ''
      substituteInPlace sweep.py tests/test_sweep.py \
        --replace-fail \
          "#!/bin/bash" \
          "#!${lib.getExe bash}"
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

      # /sys/devices/system/cpu/ does not exist in the sandbox:
      # RuntimeError: Failed to initialize cpuinfo!
      "test_adafactor_bv_default_eps_per_param"
      "test_adapt_non_rgb_input_conv"
      "test_asl_multilabel_low_precision_logits"
      "test_build_rotary_pos_embed_matches_legacy"
      "test_compiled_foreach_adam_optimizers"
      "test_create_model_transfers_multispectral_checkpoint"
      "test_dinov3_coords_rounding"
      "test_distribution_balanced_loss_edge_cases"
      "test_laprop_load_legacy_float_state"
      "test_mixed_grid_storage"
      "test_mrope_reference_precision_and_meta_init"
      "test_optimizer_low_precision"
      "test_poly_binary_cross_entropy"
      "test_poly_cross_entropy"
      "test_rope_aug_eval_initialization_and_caches"
      "test_rope_aug_output_dtype"
      "test_rotary_apply_output_dtype_and_rounding"
      "test_rotary_freqs_stay_fp32_after_cast"
      "test_two_way_loss"
      "test_zlpr_loss"
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

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "PyTorch image models, scripts, and pretrained weights";
    homepage = "https://huggingface.co/docs/timm/index";
    changelog = "https://github.com/huggingface/pytorch-image-models/blob/${finalAttrs.src.rev}/README.md#whats-new";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
