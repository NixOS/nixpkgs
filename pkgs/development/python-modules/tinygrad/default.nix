{
  lib,
  stdenv,
  config,
  buildPythonPackage,
  fetchFromGitHub,

  # patches
  replaceVars,
  addDriverRunpath,
  cudaPackages,
  llvmPackages,
  ocl-icd,
  rocmPackages,

  # build-system
  setuptools,

  # optional-dependencies
  # arm
  unicorn,
  # triton
  triton,
  # testing_minimal
  hypothesis,
  numpy,
  pytest-xdist,
  torch,
  z3-solver,
  # testing_unit
  ggml-python,
  openai,
  safetensors,
  tabulate,
  tqdm,
  # testing
  blobfile,
  boto3,
  bottle,
  capstone,
  librosa,
  networkx,
  nibabel,
  onnx,
  onnxruntime,
  opencv4,
  pandas,
  pillow,
  pycocotools,
  sentencepiece,
  tiktoken,
  transformers,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  tinygrad,

  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
}:

buildPythonPackage (finalAttrs: {
  pname = "tinygrad";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinygrad";
    repo = "tinygrad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lied19C1sAbislr2WznnCZEmOn5PA0OzMg2KOdWOYkA=";
  };

  patches =
    let
      libExtension = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    [
      (replaceVars ./patch-deps-paths.patch {
        libllvm = "${lib.getLib llvmPackages.llvm}/lib/libLLVM${libExtension}";
        libclang = "${lib.getLib llvmPackages.libclang}/lib/libclang${libExtension}";

        # Use the unwrapped variant to enable the "native" features currently unavailable in the sandbox
        clang = lib.getExe llvmPackages.clang-unwrapped;
      })
    ]
    ++ lib.optionals cudaSupport [
      (replaceVars ./patch-cuda-paths.patch {
        inherit (addDriverRunpath) driverLink;
        cuda_nvrtc = lib.getLib cudaPackages.cuda_nvrtc;

        # `cuda_fp16.h` and co. are needed at runtime to compile kernels
        cuda_cudart = lib.getInclude cudaPackages.cuda_cudart;
      })
    ]
    ++ lib.optionals rocmSupport [
      (replaceVars ./patch-rocm-paths.patch {
        comgr = lib.getLib rocmPackages.rocm-comgr;
        clr = lib.getLib rocmPackages.clr;
        rocm-runtime = lib.getLib rocmPackages.rocm-runtime;
        rocm-llvm-objdump = lib.getExe' rocmPackages.llvm.llvm "llvm-objdump";
        llvm-objdump = lib.getExe' llvmPackages.llvm "llvm-objdump";
        hipcc = lib.getExe' rocmPackages.hipcc "hipcc";
      })
    ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace tinygrad/runtime/autogen/opencl.py \
      --replace-fail \
        "dll = DLL('opencl', 'OpenCL')" \
        "dll = DLL('opencl', '${lib.getLib ocl-icd}/lib/libOpenCL.so')"

    substituteInPlace tinygrad/runtime/autogen/libc.py \
      --replace-fail \
        "dll = DLL('libc', 'c', use_errno=True)" \
        "dll = DLL('libc', '${lib.getLib stdenv.cc.libc}/lib/libc.so.6', use_errno=True)"
  '';

  __propagatedImpureHostDeps = lib.optional stdenv.hostPlatform.isDarwin "/usr/lib/libc.dylib";

  build-system = [ setuptools ];

  optional-dependencies = lib.fix (self: {
    arm = [ unicorn ];
    triton = [ triton ];
    testing_minimal = [
      hypothesis
      numpy
      pytest-xdist
      torch
      z3-solver
    ];
    testing_unit = self.testing_minimal ++ [
      ggml-python
      openai
      safetensors
      tabulate
      tqdm
    ];
    testing = self.testing_unit ++ [
      blobfile
      boto3
      bottle
      capstone
      librosa
      networkx
      nibabel
      onnx
      onnxruntime
      opencv4
      pandas
      pillow
      pycocotools
      sentencepiece
      tiktoken
      transformers
    ];
  });

  pythonImportsCheck = [
    "tinygrad"
    "tinygrad.runtime.autogen.libclang"
  ]
  ++ lib.optionals cudaSupport [
    "tinygrad.runtime.ops_cuda"
    "tinygrad.runtime.ops_nv"
  ]
  ++ lib.optionals rocmSupport [
    "tinygrad.runtime.ops_amd"
    "tinygrad.runtime.ops_hip"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "tinygrad.runtime.ops_metal"
  ];

  nativeCheckInputs = [
    llvmPackages.clang
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.testing;

  disabledTests = [
    # RuntimeError: Attempting to relocate against an undefined symbol 'fmaxf'
    "test_backward_sum_acc_dtype"
    "test_failure_27"

    # Flaky:
    # AssertionError: 2.1376906810000946 not less than 2.0
    "test_recursive_pad"

    # Require internet access
    "testCopySHMtoDefault"
    "test_benchmark_openpilot_model"
    "test_bn_alone"
    "test_bn_linear"
    "test_bn_mnist"
    "test_car"
    "test_chicken"
    "test_chicken_bigbatch"
    "test_conv_mnist"
    "test_data_parallel_resnet"
    "test_dataset_is_realized"
    "test_e2e_big"
    "test_fetch_small"
    "test_hevc_parser"
    "test_huggingface_enet_safetensors"
    "test_index_mnist"
    "test_linear_mnist"
    "test_llama_basic"
    "test_llama_bytes"
    "test_llama_control_char"
    "test_llama_early_tokenize"
    "test_llama_pat"
    "test_llama_repeat"
    "test_llama_special1"
    "test_llama_special2"
    "test_load_convnext"
    "test_load_enet"
    "test_load_enet_alt"
    "test_load_gpt2_q4_1"
    "test_load_llama2bfloat"
    "test_load_resnet"
    "test_load_sample_mxfp4"
    "test_load_sample_q6_k"
    "test_load_tinyllama_q4_0"
    "test_load_tinyllama_q8_0"
    "test_mnist_val"
    "test_openpilot_model"
    "test_resnet"
    "test_shufflenet"
    "test_transcribe_batch12"
    "test_transcribe_batch21"
    "test_transcribe_file1"
    "test_transcribe_file2"
    "test_transcribe_long"
    "test_transcribe_long_no_batch"
    "test_vgg7"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Fail with AssertionError
    "test_casts_from"
    "test_casts_to"
    "test_float_cast_to_unsigned_underflow"
    "test_int8"
    "test_int8_to_uint16_negative"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky (pass when running a smaller set of tests: tests/unit/*, but not within the full test suite)
    # AttributeError: module 'tinygrad.runtime.autogen.libclang' has no attribute 'clang_parseTranslationUnit'
    "test_gen_from_header"
    "test_struct_ordering"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Exception: forward pass failed shape (2, 3, 64, 64)
    "test_cast"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # AssertionError: Expected 1 operations, got 3
    # assert 3 == 1
    #  +  where 3 = len([ExecItem(ast=UOp(Ops.SINK, dtypes.void, arg=None, src=...
    #  +  and   1 = len([{'cnt': 3, 'type': 'graph'}])
    #
    # test/test_jit.py:695: AssertionError
    "TestJitGraphSplit"
  ];

  disabledTestPaths = [
    # Require internet access
    "test/models/test_mnist.py"
    "test/models/test_real_world.py"
    "test/testextra/test_lr_scheduler.py"

    # Files under this directory are not considered as tests by upstream and should be skipped
    "extra/"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Fatal Python error: Aborted
    # in ...onnxruntime/capi/_pybind_state.py", line 32 in <module>
    "test/models/test_onnx.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # urllib.error.URLError: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED]
    # certificate verify failed: self-signed certificate in certificate chain (_ssl.c:1032)>
    "test/models/test_whisper.py"
  ];

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests = {
      withCuda = tinygrad.override { cudaSupport = true; };
      withRocm = tinygrad.override { rocmSupport = true; };
    };

    gpuCheck = tinygrad.overridePythonAttrs (old: {
      requiredSystemFeatures = [ "cuda" ];

      pytestFlags = (old.pytestFlags or [ ]) ++ [
        # When running in parallel, with GPU support, some tests become flaky:
        # RuntimeError: Wait timeout: 30000 ms! (the signal is not set to 153, but 151)
        "--maxprocesses=1"
      ];
    });
  };

  meta = {
    description = "Simple and powerful neural network framework";
    homepage = "https://github.com/tinygrad/tinygrad";
    changelog = "https://github.com/tinygrad/tinygrad/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
