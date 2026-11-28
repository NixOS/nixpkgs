{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  mslk,
  numpy,
  nvidia-ml-py,
  torch,

  # tests
  pytestCheckHook,
  scipy,
  triton,
  python,

  # passthru
  xformers,
  writableTmpDirAsHomeHook,
}:
let
  inherit (torch) cudaSupport;
in
buildPythonPackage (finalAttrs: {
  pname = "xformers";
  version = "0.0.36";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "xformers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZQquwtDluyFOWLUVayNWW4E1wdAqgYUdNsRiwCK4KN4=";
  };

  # ModuleNotFoundError: No module named 'xformers.components'
  postPatch = ''
    touch xformers/components/__init__.py
    touch xformers/components/attention/__init__.py
  '';

  build-system = [
    setuptools
    torch
  ];

  dependencies = [
    mslk
    numpy
    torch
  ]
  ++ lib.optionals cudaSupport [
    nvidia-ml-py
  ];

  pythonImportsCheck = [
    "xformers"
    "xformers.components"
    "xformers.components.attention"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ]
  ++ lib.optionals cudaSupport [
    triton
  ];

  preCheck =
    # Make sure the tests run against the installed package
    ''
      rm -rf xformers
    ''
    # Display information about the installation
    + ''
      ${python.interpreter} -m xformers.info
    '';

  enabledTestPaths = [
    "tests"
  ];

  disabledTests =
    # The following tests fail without cudaSupport
    lib.optionals (!cudaSupport) [
      # AssertionError: Torch not compiled with CUDA enabled
      "test_flash_gqa_wrong_strides"
      "test_memeff_compile"
      "test_paged_attention"
      "test_paged_attention_flash"
      "test_triton_splitk_decoder"
      "test_triton_splitk_decoder_manyqueries"
      "test_unsupported_dropout_combine_flash_cutlass"

      # AssertionError: Should use Flash-Decoding with BMHK MQA
      "test_dispatch_decoding_bmhk"

      # AssertionError: Should use Flash-Decoding with MQA
      "test_dispatch_decoding_bmghk"
    ];

  disabledTestPaths = lib.optionals (!lib.meta.availableOn stdenv.hostPlatform triton) [
    # ModuleNotFoundError: No module named 'triton'
    "tests/test_mslk_compat.py::test_reexports_exist_in_mslk[xformers.ops.fmha._triton.splitk_kernels]"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.gpuCheck = xformers.overridePythonAttrs (old: {
    requiredSystemFeatures = [ "cuda" ];

    disabledTests = (old.disabledTests or [ ]) ++ [
      # `fa3F@0.0.0` is not supported because:
      #   operator wasn't built - see `python -m xformers.info` for more info
      "test_merge_training"

      # Not enough GPU memory (on a 20G RTX 4000 SFF Ada)
      # triton.runtime.errors.OutOfResources: out of resource:
      # shared memory, Required: 147456, Hardware limit: 101376.
      "test_consistency"
      "test_forward"
      "test_logsumexp"
      "test_mqa_decoding"
      "test_tree_attention"

      # Tolerance issues:
      # AssertionError: cutlassF-pt+cutlassB-pt:key: out=4.65625 and ref=3.1875
      # (diff=0.251953125 > 0) at (np.int64(0), np.int64(0), np.int64(4))
      # of shape (1, 4, 8) / atol=0.9, rtol=0.1/ total failing elements: 1 (3.12%)
      "test_backward"

      # AssertionError: Legacy CUDA profiling requires use_cpu=True
      "test_profiler_dispatcher_stream_workaround"

      # torch.AcceleratorError: CUDA error: out of memory (in cuStreamCreateWithPriority)
      "test_cuda_streams"
    ];

    disabledTestPaths = (old.disabledTestPaths or [ ]) ++ [
      # ValueError: `flydslF` is not supported because: FlyDSL unavailable on this device/arch
      # (FlyDSL is a ROCm-only backend)
      "tests/test_mem_eff_attention.py::test_unsupported_stride_alignment[flydslF]"
      "tests/test_mem_eff_attention.py::test_unsupported_stride_lastdim[flydslF]"

      # AssertionError: memory_efficient_attention: 0.0 flops, expected 3221225472
      "tests/test_profiler.py::test_analyze_prof_memeff[-flash]"
      "tests/test_profiler.py::test_analyze_prof_memeff[causal-flash]"

      # RuntimeError: NCCL split failed: unhandled cuda error
      "tests/test_sequence_parallel_fused_ops.py::test_sequence_parallel_fused[compile-fp32-ugly-shapes-all-gather-singleton]"
    ];

    nativeCheckInputs = old.nativeCheckInputs ++ [
      writableTmpDirAsHomeHook
    ];
  });

  meta = {
    description = "Collection of composable Transformer building blocks";
    homepage = "https://github.com/facebookresearch/xformers";
    changelog = "https://github.com/facebookresearch/xformers/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      GaetanLepage
      happysalada
    ];
  };
})
