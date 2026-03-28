{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # buildInputs
  llvmPackages,

  # build-system
  setuptools,

  # dependencies
  torch,
  torchcodec,

  # tests
  inflect,
  parameterized,
  pytestCheckHook,
  pytorch-lightning,
  scipy,
  sentencepiece,
  unidecode,

  # passthru
  torchaudio,

  cudaSupport ? torch.cudaSupport,
  cudaPackages,
  rocmSupport ? torch.rocmSupport,
}:

buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "torchaudio";
  version = "2.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "audio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TncROn9wfn5HOaIvupS2/KD9JCgwfHyfnbZRc+SiqJ0=";
  };

  env = {
    # CTC seems to be missing no matter what. No obvious flag to force its compilation.
    TORCHAUDIO_TEST_ALLOW_SKIP_IF_NO_CTC_DECODER = 1;

    # CUDA
    USE_CUDA = cudaSupport;
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" torch.cudaCapabilities}";
    TORCHAUDIO_TEST_ALLOW_SKIP_IF_NO_CUCTC_DECODER = 1;
    TORCHAUDIO_TEST_ALLOW_SKIP_IF_NO_CUDA = 1;
    TORCHAUDIO_TEST_ALLOW_SKIP_IF_NO_MULTIGPU_CUDA = 1;

    # At of 2026-03-27, the default `cudaPackages` version is 12.9.1
    # According to Nvidia, it should support GCC versions up to 14.x:
    # -> https://docs.nvidia.com/cuda/archive/12.9.1/cuda-installation-guide-linux/index.html#host-compiler-support-policy
    # However, PyTorch's *strict* upper bound is 14.0:
    # -> https://github.com/pytorch/pytorch/blob/v2.11.0/torch/utils/cpp_extension.py#L75
    # Hence, the build fails with:
    #   RuntimeError: The current installed version of g++ (14.3.0) is greater than the maximum
    #   required version by CUDA 12.9. Please make sure to use an adequate version of g++
    #   (>=6.0.0, <14.0).
    # Hence, we disable the version check to silence the error:
    TORCH_DONT_CHECK_COMPILER_ABI = cudaSupport;

    # ROCM
    USE_ROCM = rocmSupport;
    PYTORCH_ROCM_ARCH = lib.optionalString rocmSupport torch.gpuTargetString;
    ROCM_PATH = lib.optionalString rocmSupport torch.rocmtoolkit_joined;

    # demucs is not packaged in nixpkgs and is archived anyway
    TORCHAUDIO_TEST_ALLOW_SKIP_IF_NO_MOD_demucs = true;

    # fairseq is unmaintained and broken in nixpkgs
    TORCHAUDIO_TEST_ALLOW_SKIP_IF_NO_MOD_fairseq = true;

    # Fails even on python>3.10 with:
    #   RuntimeError: Test is known to fail for Python 3.10, disabling for now
    #   See: https://github.com/pytorch/audio/pull/2224#issuecomment-1048329450
    TORCHAUDIO_TEST_ALLOW_SKIP_IF_ON_PYTHON_310 = true;
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs =
    lib.optionals cudaSupport [
      cudaPackages.cuda_cudart
    ]
    ++ lib.optionals torch.stdenv.cc.isClang [
      llvmPackages.openmp
    ];

  dependencies = [
    torch
    torchcodec
  ];

  pythonImportsCheck = [ "torchaudio" ];

  nativeCheckInputs = [
    inflect
    parameterized
    pytestCheckHook
    pytorch-lightning
    scipy
    sentencepiece
    unidecode
  ];

  disabledTestPaths = [
    # Require internet access
    "test/integration_tests"
  ];

  disabledTests = [
    # AssertionError: Tensor-likes are not close!
    # Mismatched elements: 1070 / 32800 (3.3%)
    "test_amplitude_to_DB"
    "test_amplitude_to_DB_power"

    # Very long to run
    "AutogradCPUTest"
  ];

  passthru.gpuCheck = torchaudio.overridePythonAttrs (old: {
    requiredSystemFeatures = [ "cuda" ];

    env = (old.env or { }) // {
      TORCHAUDIO_TEST_ALLOW_SKIP_IF_NO_CUCTC_DECODER = 0;
      TORCHAUDIO_TEST_ALLOW_SKIP_IF_NO_CUDA = 0;
    };
  });

  meta = {
    description = "PyTorch audio library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/audio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    platforms =
      lib.platforms.linux ++ lib.optionals (!cudaSupport && !rocmSupport) lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      GaetanLepage
      caniko
      junjihashimoto
    ];
  };
})
