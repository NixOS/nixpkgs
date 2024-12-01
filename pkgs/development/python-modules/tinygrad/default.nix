{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  substituteAll,
  addDriverRunpath,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
  cudaPackages,
  ocl-icd,
  rocmPackages,
  stdenv,

  # build-system
  setuptools,

  # optional-dependencies
  llvmlite,
  triton,
  unicorn,

  # tests
  blobfile,
  bottle,
  clang,
  hexdump,
  hypothesis,
  librosa,
  networkx,
  numpy,
  onnx,
  pillow,
  pytest-xdist,
  pytestCheckHook,
  safetensors,
  sentencepiece,
  tiktoken,
  torch,
  tqdm,
  transformers,

  tinygrad,
}:

buildPythonPackage rec {
  pname = "tinygrad";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinygrad";
    repo = "tinygrad";
    rev = "refs/tags/v${version}";
    hash = "sha256-IIyTb3jDUSEP2IXK6DLsI15E5N34Utt7xv86aTHpXf8=";
  };

  patches = [
    (substituteAll {
      src = ./fix-dlopen-cuda.patch;
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
    ''
      substituteInPlace tinygrad/runtime/ops_clang.py \
        --replace-fail "'clang'" "'${lib.getExe clang}'"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace tinygrad/runtime/autogen/opencl.py \
        --replace-fail "ctypes.util.find_library('OpenCL')" "'${ocl-icd}/lib/libOpenCL.so'"
    ''
    # `cuda_fp16.h` and co. are needed at runtime to compile kernels
    + lib.optionalString cudaSupport ''
      substituteInPlace tinygrad/runtime/support/compiler_cuda.py \
        --replace-fail \
        ', "-I/usr/local/cuda/include", "-I/usr/include", "-I/opt/cuda/include/"' \
        ', "-I${lib.getDev cudaPackages.cuda_cudart}/include/"'
    ''
    + lib.optionalString rocmSupport ''
      substituteInPlace tinygrad/runtime/autogen/hip.py \
        --replace-fail "/opt/rocm/lib/libamdhip64.so" "${rocmPackages.clr}/lib/libamdhip64.so" \
        --replace-fail "/opt/rocm/lib/libhiprtc.so" "${rocmPackages.clr}/lib/libhiprtc.so" \

      substituteInPlace tinygrad/runtime/autogen/comgr.py \
        --replace-fail "/opt/rocm/lib/libamd_comgr.so" "${rocmPackages.rocm-comgr}/lib/libamd_comgr.so"
    '';

  build-system = [ setuptools ];

  optional-dependencies = {
    llvm = [ llvmlite ];
    arm = [ unicorn ];
    triton = [ triton ];
  };

  pythonImportsCheck =
    [
      "tinygrad"
    ]
    ++ lib.optionals cudaSupport [
      "tinygrad.runtime.ops_nv"
    ];

  nativeCheckInputs = [
    blobfile
    bottle
    clang
    hexdump
    hypothesis
    librosa
    networkx
    numpy
    onnx
    pillow
    pytest-xdist
    pytestCheckHook
    safetensors
    sentencepiece
    tiktoken
    torch
    tqdm
    transformers
  ] ++ networkx.optional-dependencies.extra;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests =
    [
      # Fixed in https://github.com/tinygrad/tinygrad/pull/7792
      # TODO: re-enable at next release
      "test_kernel_cache_in_action"

      # Require internet access
      "test_benchmark_openpilot_model"
      "test_bn_alone"
      "test_bn_linear"
      "test_bn_mnist"
      "test_car"
      "test_chicken"
      "test_chicken_bigbatch"
      "test_conv_mnist"
      "testCopySHMtoDefault"
      "test_data_parallel_resnet"
      "test_e2e_big"
      "test_fetch_small"
      "test_huggingface_enet_safetensors"
      "test_index_mnist"
      "test_linear_mnist"
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
      # Fixed in https://github.com/tinygrad/tinygrad/pull/7796
      # TODO: re-enable at next release
      "test_interpolate_bilinear"

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
    # Tests segfault on darwin
    badPlatforms = [ lib.systems.inspect.patterns.isDarwin ];
  };
}
