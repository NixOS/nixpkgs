{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  torch,
  setuptools,

  # buildInputs
  openmp,

  # dependencies
  numpy,
  pynvml,

  # tests
  einops,
  fairscale,
  hydra-core,
  networkx,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  scipy,
  timm,
  transformers,
  triton,
  python,

  # passthru
  xformers,
  writableTmpDirAsHomeHook,
}:
let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;

  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
buildPythonPackage.override { stdenv = effectiveStdenv; } (finalAttrs: {
  pname = "xformers";
  version = "0.0.35";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "xformers";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-UqpRHLN0INpW6sA8DbQCSeL8uhS+IoW60UPVUIh1NY0=";
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

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  env = lib.attrsets.optionalAttrs cudaSupport {
    # Don't silently fallback to a non-CUDA build
    FORCE_CUDA = 1;

    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" cudaCapabilities}";
  };

  buildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [
      openmp
    ]
    ++ lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cudart # cuda_runtime_api.h
        libcusparse # cusparse.h
        cuda_cccl # nv/target
        libcublas # cublas_v2.h
        libcusolver # cusolverDn.h
        libcurand # curand_kernel.h
      ]
    );

  nativeBuildInputs =
    lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      openmp.dev
    ];

  dependencies = [
    numpy
    torch
  ]
  ++ lib.optionals cudaSupport [
    pynvml
  ];

  pythonImportsCheck = [
    "xformers"
    "xformers.components"
    "xformers.components.attention"
  ];

  nativeCheckInputs = [
    einops
    fairscale
    hydra-core
    networkx
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
    scipy
    timm
    transformers
    triton
  ];

  preCheck =
    # Otherwise the CPP bindings are not available and the GPU tests fail with:
    # `fa2F@2.5.7-pt` is not supported because:
    #     xFormers wasn't build with CUDA support: False
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

  disabledTestPaths = [
    # Those tests require access to the GPU and should be tagged accordingly:
    # https://github.com/facebookresearch/xformers/pull/1385
    "tests/test_fwbw_overlap.py"
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

  passthru.gpuCheck = xformers.overridePythonAttrs (old: {
    requiredSystemFeatures = [ "cuda" ];

    # Run all tests, including the ones that need a GPU
    disabledTestPaths = [ ];

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

      # RuntimeError: two_four_sgemm_cutlass, /build/source/xformers/csrc/sparse24/gemm.cu:190,
      # Got CUTLASS error: Error Internal
      "test_linearw24"
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
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
