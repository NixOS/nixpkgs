{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
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

buildPythonPackage (finalAttrs: {
  pname = "torchao";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "ao";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N5s2AzkK9HmUT+qVq2owrB/53izDlzd25fqThjA3hPQ=";
  };

  # AttributeError: 'typing.Union' object has no attribute '__module__' and no __dict__ for setting
  # new attributes. Did you mean: '__reduce__'?
  disabled = pythonAtLeast "3.14";

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

  pythonImportsCheck = [ "torchao" ];

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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: Scalars are not equal!
    "test_comm"
    "test_fsdp2"
    "test_fsdp2_correctness"
    "test_precompute_bitnet_scale"
    "test_qlora_fsdp2"
    "test_uneven_shard"

    # AssertionError: tensor(42.4146, grad_fn=<MulBackward0>) not greater than 43.0
    "test_weight_only_quant"

    # RuntimeError: No packed_weights_format was selected
    "TestIntxOpaqueTensor"
    "test_accuracy_kleidiai"

    # RuntimeError: quantized engine NoQEngine is not supported
    "test_smooth_linear_cpu"
    "test_smooth_linear_edge_cases"

    # RuntimeError: Attempted to set the storage of a tensor on device "cpu" to a storage on
    # different device "mps:0".
    # This is no longer allowed; the devices must match.
    "test_pin_memory"

    # AttributeError: module 'torch.mps' has no attribute 'memory_allocated'
    "test_get_group_qparams_symmetric_memory"
    # AttributeError: module 'torch.mps' has no attribute 'reset_peak_memory_stats'
    "test_quantized_model_streaming"

    # TypeError: Trying to convert Float8_e4m3fn to the MPS backend but it does not have support for that dtype.
    "test_dequantize_affine_float8_float8_e4m3fn_bfloat16_block_size0"
    "test_dequantize_affine_float8_float8_e4m3fn_bfloat16_block_size1"
    "test_dequantize_affine_float8_float8_e4m3fn_bfloat16_block_size2"
    "test_dequantize_affine_float8_float8_e4m3fn_bfloat16_block_size3"
    "test_dequantize_affine_float8_float8_e4m3fn_float32_block_size0"
    "test_dequantize_affine_float8_float8_e4m3fn_float32_block_size1"
    "test_dequantize_affine_float8_float8_e4m3fn_float32_block_size2"
    "test_dequantize_affine_float8_float8_e4m3fn_float32_block_size3"
    "test_dequantize_affine_float8_float8_e5m2_bfloat16_block_size0"
    "test_dequantize_affine_float8_float8_e5m2_bfloat16_block_size1"
    "test_dequantize_affine_float8_float8_e5m2_bfloat16_block_size2"
    "test_dequantize_affine_float8_float8_e5m2_bfloat16_block_size3"
    "test_dequantize_affine_float8_float8_e5m2_float32_block_size0"
    "test_dequantize_affine_float8_float8_e5m2_float32_block_size1"
    "test_dequantize_affine_float8_float8_e5m2_float32_block_size2"
    "test_dequantize_affine_float8_float8_e5m2_float32_block_size3"
    "test_dequantize_affine_float8_scale_broadcasting"
    "test_subclass_slice_subclass2_shape0_device_mps"
    "test_subclass_slice_subclass2_shape1_device_mps"
    # torch._inductor.exc.InductorError: KeyError: torch.float8_e4m3fn
    "test_optim_default_dtype_bf16_optim_name_AdamFp8_device_mps"
    "test_optim_smoke_optim_name_AdamWFp8_bfloat16_device_mps"
    "test_optim_smoke_optim_name_AdamWFp8_float32_device_mps"
    "test_param_groups_optim_name_AdamFp8_device_mps"
    "test_subclass_slice_subclass0_shape0_device_mps"
    "test_optim_smoke_optim_name_AdamFp8_bfloat16_device_mps"
    "test_optim_smoke_optim_name_AdamFp8_float32_device_mps"
    "test_subclass_slice_subclass0_shape1_device_mps"

    # Crash (Trace/BPT trap: 5)
    "test_copy__mismatch_metadata_apply_quant0"
    "test_copy__mismatch_metadata_apply_quant1"
    "test_copy__mismatch_metadata_apply_quant2"
    "test_copy__mismatch_metadata_apply_quant3"
    "test_copy__mismatch_metadata_apply_quant4"
    "test_from_scaled_tc_floatx_compile_ebits_2_mbits_2_mps"
    "test_from_scaled_tc_floatx_compile_ebits_3_mbits_2_mps"
    "test_from_tc_floatx_correctness_ebits_2_mbits_2_mps"
    "test_from_tc_floatx_correctness_ebits_3_mbits_2_mp"
    "test_gptq_with_input_recorder"
    "test_int4wo_cuda_serialization"
    "test_mm_int4wo_mps_bfloat16"
    "test_module_fqn_to_config_default"
    "test_module_fqn_to_config_module_name"
    "test_module_fqn_to_config_skip"
    "test_pack_tc_fp6_correctness_mps"
    "test_qat_4w_linear"
    "test_qat_4w_primitives"
    "test_qat_4w_quantizer"
    "test_quantize_api_compile_False"
    "test_quantize_api_compile_True"
    "test_smoketest_linear_bfloat16"
    "test_smoketest_linear_float16"
    "test_smoketest_linear_float32"
    "test_tensor_core_layout_transpose"
    "test_tensor_deepcopy_input_size1"
    "test_tensor_deepcopy_input_size2"
    "test_tensor_deepcopy_input_size_262144"
    "test_to_copy_bfloat16"
    "test_to_copy_float16"
    "test_to_copy_float32"
    "test_to_cuda"
    "test_to_module"
    "test_to_scaled_tc_floatx_compile_ebits_2_mbits_2_mps"
    "test_to_scaled_tc_floatx_compile_ebits_3_mbits_2_mps"
    "test_workflow_e2e_numerics_config0"
    "test_workflow_e2e_numerics_config1"
    "test_workflow_e2e_numerics_config4"
    "test_workflow_e2e_numerics_config5"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Flaky: [gw0] node down: keyboard-interrupt
    "test_int8_weight_only_quant_with_freeze_0_cpu"
    "test_int8_weight_only_quant_with_freeze_1_cpu"
    "test_int8_weight_only_quant_with_freeze_2_cpu"

    # Illegal instruction in subclass_4bit.py::dequantize
    "test_subclass_slice"
  ];

  disabledTestPaths = [
    # ImportError: cannot import name 'ToyLinearModel' from 'torchao.testing.model_architectures'
    "benchmarks/microbenchmarks/test/test_benchmark_profiler.py"
    "benchmarks/microbenchmarks/test/test_utils.py"

    # ImportError: cannot import name 'fp8_blockwise_weight_dequant' from 'torchao.kernel.blockwise_quantization'
    "test/kernel/test_blockwise_triton.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
    changelog = "https://github.com/pytorch/ao/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      GaetanLepage
      sarahec
    ];
  };
})
