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
  llvmlite,
  triton,
  unicorn,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  blobfile,
  bottle,
  capstone,
  clang,
  hexdump,
  hypothesis,
  jax,
  librosa,
  ml-dtypes,
  networkx,
  numpy,
  onnx,
  onnxruntime,
  pillow,
  pytest-xdist,
  safetensors,
  sentencepiece,
  tiktoken,
  torch,
  tqdm,
  transformers,
  z3-solver,

  # passthru
  tinygrad,

  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
}:

buildPythonPackage rec {
  pname = "tinygrad";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinygrad";
    repo = "tinygrad";
    tag = "v${version}";
    hash = "sha256-VG2rhkiwPFN3JYSBbqrwCdqhdGE8GY6oEatMSCydhw8=";
  };

  patches = [
    (replaceVars ./fix-dlopen-cuda.patch {
      inherit (addDriverRunpath) driverLink;
      libnvrtc =
        if cudaSupport then
          "${lib.getLib cudaPackages.cuda_nvrtc}/lib/libnvrtc.so"
        else
          "Please import nixpkgs with `config.cudaSupport = true`";
    })
  ];

  postPatch =
    # Patch `clang` directly in the source file
    # Use the unwrapped variant to enable the "native" features currently unavailable in the sandbox
    ''
      substituteInPlace tinygrad/runtime/ops_cpu.py \
        --replace-fail "getenv(\"CC\", 'clang')" "'${lib.getExe llvmPackages.clang-unwrapped}'"
    ''
    + ''
      substituteInPlace tinygrad/runtime/autogen/libc.py \
        --replace-fail "ctypes.util.find_library('c')" "'${stdenv.cc.libc}/lib/libc.so.6'"
    ''
    + ''
      substituteInPlace tinygrad/runtime/support/llvm.py \
        --replace-fail "ctypes.util.find_library('LLVM')" "'${lib.getLib llvmPackages.llvm}/lib/libLLVM.so'"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace tinygrad/runtime/autogen/opencl.py \
        --replace-fail "ctypes.util.find_library('OpenCL')" "'${ocl-icd}/lib/libOpenCL.so'"
    ''
    # test/test_tensor.py imports the PTX variable from the cuda_compiler.py file.
    # This import leads to loading the libnvrtc.so library that is not substituted when cudaSupport = false.
    # -> As a fix, we hardcode this variable to False
    + lib.optionalString (!cudaSupport) ''
      substituteInPlace test/test_tensor.py \
        --replace-fail "from tinygrad.runtime.support.compiler_cuda import PTX" "PTX = False"
    ''
    # `cuda_fp16.h` and co. are needed at runtime to compile kernels
    + lib.optionalString cudaSupport ''
      substituteInPlace tinygrad/runtime/support/compiler_cuda.py \
        --replace-fail \
        '"-I/usr/local/cuda/include", "-I/usr/include", "-I/opt/cuda/include"' \
        '"-I${lib.getDev cudaPackages.cuda_cudart}/include/"'
    ''
    + lib.optionalString rocmSupport ''
      substituteInPlace tinygrad/runtime/autogen/hip.py \
        --replace-fail "/opt/rocm/" "${rocmPackages.clr}/"

      substituteInPlace tinygrad/runtime/support/compiler_hip.py \
        --replace-fail "/opt/rocm/include" "${rocmPackages.clr}/include"

      substituteInPlace tinygrad/runtime/support/compiler_hip.py \
        --replace-fail "/opt/rocm/llvm" "${rocmPackages.llvm.llvm}"

      substituteInPlace tinygrad/runtime/autogen/comgr.py \
        --replace-fail "/opt/rocm/" "${rocmPackages.rocm-comgr}/"
    '';

  build-system = [ setuptools ];

  optional-dependencies = {
    llvm = [ llvmlite ];
    arm = [ unicorn ];
    triton = [ triton ];
  };

  pythonImportsCheck = [
    "tinygrad"
  ]
  ++ lib.optionals cudaSupport [
    "tinygrad.runtime.ops_nv"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook

    blobfile
    bottle
    capstone
    clang
    hexdump
    hypothesis
    jax
    librosa
    ml-dtypes
    networkx
    numpy
    onnx
    onnxruntime
    pillow
    pytest-xdist
    safetensors
    sentencepiece
    tiktoken
    torch
    tqdm
    transformers
    z3-solver
  ]
  ++ networkx.optional-dependencies.extra;

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
    "test_load_llama2bfloat"
    "test_load_resnet"
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
  ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
    # Fail with AssertionError
    "test_casts_from"
    "test_casts_to"
    "test_int8"
    "test_int8_to_uint16_negative"
  ];

  disabledTestPaths = [
    # Require internet access
    "test/models/test_mnist.py"
    "test/models/test_real_world.py"
    "test/testextra/test_lr_scheduler.py"

    # Files under this directory are not considered as tests by upstream and should be skipped
    "extra/"
  ];

  passthru.tests = {
    withCuda = tinygrad.override { cudaSupport = true; };
  };

  meta = {
    description = "Simple and powerful neural network framework";
    homepage = "https://github.com/tinygrad/tinygrad";
    changelog = "https://github.com/tinygrad/tinygrad/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    badPlatforms = [
      # Fatal Python error: Aborted
      # onnxruntime/capi/_pybind_state.py", line 32 in <module>
      "aarch64-linux"

      # Tests segfault on darwin
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
