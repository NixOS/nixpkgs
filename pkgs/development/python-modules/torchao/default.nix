{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,

  # build-system
  setuptools,

  # nativeBuildInputs
  cmake,

  # buildInputs
  cpuinfo,
  llvmPackages,

  # dependencies
  torch,

  # tests
  bitsandbytes,
  expecttest,
  fire,
  pytest-xdist,
  pytestCheckHook,
  parameterized,
  tabulate,
  transformers,
  unittest-xml-reporting,
}:

buildPythonPackage rec {
  pname = "torchao";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "ao";
    tag = "v${version}";
    hash = "sha256-L9Eoul7Nar/+gS44+hA8JbfxCgkMH5xAMCleggAZn7c=";
  };

  patches = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    ./use-system-cpuinfo.patch
    (replaceVars ./use-llvm-openmp.patch {
      inherit (llvmPackages) openmp;
    })
  ];

  build-system = [
    setuptools
  ];

  nativeBuildInputs = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    cmake
  ];
  dontUseCmakeConfigure = true;

  buildInputs = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    cpuinfo
  ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    # Otherwise, torch will fail to include `omp.h`:
    # torch._inductor.exc.InductorError: CppCompileError: C++ compile error
    # OpenMP support not found.
    llvmPackages.openmp
  ];

  dependencies = [
    torch
  ];

  env = {
    USE_SYSTEM_LIBS = true;
  };

  # Otherwise, the tests are loading the python module from the source instead of the installed one
  preCheck = ''
    rm -rf torchao
  '';

  pythonImportsCheck = [
    "torchao"
  ];

  nativeCheckInputs = [
    bitsandbytes
    expecttest
    fire
    parameterized
    pytest-xdist
    pytestCheckHook
    tabulate
    transformers
    unittest-xml-reporting
  ];

  disabledTests = [
    # Requires internet access
    "test_on_dummy_distilbert"

    # FileNotFoundError: [Errno 2] No such file or directory: 'checkpoints/meta-llama/Llama-2-7b-chat-hf/model.pth'
    "test_gptq_mt"

    # KeyError: '_guards_fn
    "test_add"
    "test_add_relu"
    "test_allow_exported_model_train_eval"
    "test_allow_exported_model_train_eval_idempotent"
    "test_conv2d"
    "test_disallow_eval_train"
    "test_dynamic_linear"
    "test_fold_bn_erases_bn_node"
    "test_fold_bn_erases_bn_node"
    "test_maxpool2d"
    "test_move_exported_model_bn_device_cpu"
    "test_move_exported_model_dropout"
    "test_move_exported_model_dropout_inplace"
    "test_preserve_nn_module_stack"
    "test_qat_bn_conv2d"
    "test_qat_conv2d"
    "test_qat_conv2d_binary"
    "test_qat_conv2d_binary2"
    "test_qat_conv2d_binary_unary"
    "test_qat_conv2d_unary"
    "test_qat_conv_bn_bias_derived_qspec"
    "test_qat_conv_bn_fusion"
    "test_qat_conv_bn_fusion_literal_args"
    "test_qat_conv_bn_fusion_no_conv_bias"
    "test_qat_conv_bn_per_channel_weight_bias"
    "test_qat_conv_bn_relu_fusion"
    "test_qat_conv_bn_relu_fusion_no_conv_bias"
    "test_qat_conv_transpose_bn"
    "test_qat_conv_transpose_bn_relu"
    "test_qat_per_channel_weight_custom_dtype"
    "test_qat_preserve_source_fn_stack"
    "test_qat_qconv2d"
    "test_qat_qconv2d_add"
    "test_qat_qconv2d_add_relu"
    "test_qat_qconv2d_hardswish"
    "test_qat_qconv2d_hardtanh"
    "test_qat_qconv2d_relu"
    "test_qat_qconv2d_relu6"
    "test_qat_qconv2d_silu"
    "test_qat_update_shared_qspec"
    "test_qdq"
    "test_qdq_per_channel"
    "test_reentrant"
    "test_static_linear"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # AssertionError: tensor(False) is not true
    "test_quantize_per_token_cpu"

    # RuntimeError: failed to initialize QNNPACK
    "test_smooth_linear_cpu"

    # torch._inductor.exc.InductorError: LoweringException: AssertionError: Expect L1_cache_size > 0 but got 0
    "test_int8_weight_only_quant_with_freeze_0_cpu"
    "test_int8_weight_only_quant_with_freeze_1_cpu"
    "test_int8_weight_only_quant_with_freeze_2_cpu"

    # FileNotFoundError: [Errno 2] No such file or directory: 'test.pth'
    "test_save_load_int4woqtensors_2_cpu"
    "test_save_load_int8woqtensors_0_cpu"
    "test_save_load_int8woqtensors_1_cpu"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # AssertionError: Scalars are not equal!
    "test_comm"
    "test_fsdp2"
    "test_fsdp2_correctness"
    "test_precompute_bitnet_scale"
    "test_qlora_fsdp2"
    "test_uneven_shard"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # RuntimeError: No packed_weights_format was selected
    "TestIntxOpaqueTensor"
    "test_accuracy_kleidiai"

    # RuntimeError: quantized engine NoQEngine is not supported
    "test_smooth_linear_cpu"
    "test_smooth_linear_edge_cases"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Flaky: [gw0] node down: keyboard-interrupt
    "test_int8_weight_only_quant_with_freeze_0_cpu"
    "test_int8_weight_only_quant_with_freeze_1_cpu"
    "test_int8_weight_only_quant_with_freeze_2_cpu"
  ];

  disabledTestPaths = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Require unpackaged 'coremltools'
    "test/prototype/test_groupwise_lowbit_weight_lut_quantizer.py"

    # AttributeError: '_OpNamespace' 'mkldnn' object has no attribute '_is_mkldnn_acl_supported'
    "test/quantization/pt2e/test_arm_inductor_quantizer.py"
    "test/quantization/pt2e/test_x86inductor_fusion.py"
    "test/quantization/pt2e/test_x86inductor_quantizer.py"
  ];

  meta = {
    description = "PyTorch native quantization and sparsity for training and inference";
    homepage = "https://github.com/pytorch/ao";
    changelog = "https://github.com/pytorch/ao/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
