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
  stdenv,
  rocmPackages,
  # build-system
  setuptools,
  wheel,
  # dependencies
  numpy,
  tqdm,
  # nativeCheckInputs
  clang,
  hexdump,
  hypothesis,
  librosa,
  onnx,
  pillow,
  pytest-xdist,
  pytestCheckHook,
  safetensors,
  sentencepiece,
  tiktoken,
  torch,
  transformers,
}:

buildPythonPackage rec {
  pname = "tinygrad";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tinygrad";
    repo = "tinygrad";
    rev = "refs/tags/v${version}";
    hash = "sha256-opBxciETZruZjHqz/3vO7rogzjvVJKItulIiok/Zs2Y=";
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
    ''
      substituteInPlace tinygrad/runtime/autogen/opencl.py \
        --replace-fail "ctypes.util.find_library('OpenCL')" "'${ocl-icd}/lib/libOpenCL.so'"
    ''
    # hipGetDevicePropertiesR0600 is a symbol from rocm-6. We are currently at rocm-5.
    # We are not sure that this works. Remove when rocm gets updated to version 6.
    + lib.optionalString rocmSupport ''
      substituteInPlace extra/hip_gpu_driver/hip_ioctl.py \
        --replace-fail "processor = platform.processor()" "processor = ${stdenv.hostPlatform.linuxArch}"
      substituteInPlace tinygrad/runtime/autogen/hip.py \
        --replace-fail "/opt/rocm/lib/libamdhip64.so" "${rocmPackages.clr}/lib/libamdhip64.so" \
        --replace-fail "/opt/rocm/lib/libhiprtc.so" "${rocmPackages.clr}/lib/libhiprtc.so" \
        --replace-fail "hipGetDevicePropertiesR0600" "hipGetDeviceProperties"

      substituteInPlace tinygrad/runtime/autogen/comgr.py \
        --replace-fail "/opt/rocm/lib/libamd_comgr.so" "${rocmPackages.rocm-comgr}/lib/libamd_comgr.so"
    '';

  build-system = [
    setuptools
    wheel
  ];

  dependencies =
    [
      numpy
      tqdm
    ]
    ++ lib.optionals stdenv.isDarwin [
      # pyobjc-framework-libdispatch
      # pyobjc-framework-metal
    ];

  pythonImportsCheck = [ "tinygrad" ];

  nativeCheckInputs = [
    clang
    hexdump
    hypothesis
    librosa
    onnx
    pillow
    pytest-xdist
    pytestCheckHook
    safetensors
    sentencepiece
    tiktoken
    torch
    transformers
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests =
    [
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
      "test_linear_mnist"
      "test_load_convnext"
      "test_load_enet"
      "test_load_enet_alt"
      "test_load_llama2bfloat"
      "test_load_resnet"
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
    # Fail on aarch64-linux with AssertionError
    ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
      "test_casts_to"
      "test_casts_to"
      "test_int8_to_uint16_negative"
      "test_casts_to"
      "test_casts_to"
      "test_casts_from"
      "test_casts_to"
      "test_int8"
      "test_casts_to"
    ];

  disabledTestPaths =
    [
      # Require internet access
      "test/models/test_mnist.py"
      "test/models/test_real_world.py"
      "test/testextra/test_lr_scheduler.py"
    ]
    ++ lib.optionals (!rocmSupport) [ "extra/hip_gpu_driver/" ];

  meta = with lib; {
    description = "Simple and powerful neural network framework";
    homepage = "https://github.com/tinygrad/tinygrad";
    changelog = "https://github.com/tinygrad/tinygrad/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
    # Requires unpackaged pyobjc-framework-libdispatch and pyobjc-framework-metal
    broken = stdenv.isDarwin;
  };
}
