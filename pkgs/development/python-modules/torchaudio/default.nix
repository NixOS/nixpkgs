{
  lib,
  symlinkJoin,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  cmake,
  pkg-config,
  ninja,

  # buildInputs
  ffmpeg_6-full,
  pybind11,
  sox,
  torch,
  llvmPackages,

  cudaSupport ? torch.cudaSupport,
  cudaPackages,
  rocmSupport ? torch.rocmSupport,
  rocmPackages,

  gpuTargets ? [ ],
}:

let
  # TODO: Reuse one defined in torch?
  # Some of those dependencies are probably not required,
  # but it breaks when the store path is different between torch and torchaudio
  rocmtoolkit_joined = symlinkJoin {
    name = "rocm-merged";

    paths = with rocmPackages; [
      rocm-core
      clr
      rccl
      miopen
      rocrand
      rocblas
      rocsparse
      hipsparse
      rocthrust
      rocprim
      hipcub
      roctracer
      rocfft
      rocsolver
      hipfft
      hipsolver
      hipblas-common
      hipblas
      rocminfo
      rocm-comgr
      rocm-device-libs
      rocm-runtime
      clr.icd
      hipify
    ];

    # Fix `setuptools` not being found
    postBuild = ''
      rm -rf $out/nix-support
    '';
  };
  # Only used for ROCm
  gpuTargetString = lib.strings.concatStringsSep ";" (
    if gpuTargets != [ ] then
      # If gpuTargets is specified, it always takes priority.
      gpuTargets
    else if rocmSupport then
      rocmPackages.clr.gpuTargets
    else
      throw "No GPU targets specified"
  );
in
buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.9.1";
  pyproject = true;

  stdenv = torch.stdenv;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "audio";
    tag = "v${version}";
    hash = "sha256-tTilG/haU3OycSWqA5LR3egcxHVRg/yHJ8JB2rz3aKw=";
  };

  patches = [
    ./0001-setup.py-propagate-cmakeFlags.patch
  ];

  postPatch = lib.optionalString rocmSupport ''
    # There is no .info/version-dev, only .info/version
    substituteInPlace cmake/LoadHIP.cmake \
      --replace-fail "/.info/version-dev" "/.info/version"
  '';

  env = {
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" torch.cudaCapabilities}";
  };

  # https://github.com/pytorch/audio/blob/v2.1.0/docs/source/build.linux.rst#optional-build-torchaudio-with-a-custom-built-ffmpeg
  FFMPEG_ROOT = symlinkJoin {
    name = "ffmpeg";
    paths = [
      ffmpeg_6-full.bin
      ffmpeg_6-full.dev
      ffmpeg_6-full.lib
    ];
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ]
  ++ lib.optionals rocmSupport (
    with rocmPackages;
    [
      clr
      rocblas
      hipblas
    ]
  );

  buildInputs = [
    ffmpeg_6-full
    pybind11
    sox
    torch.cxxdev
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  dependencies = [ torch ];

  BUILD_SOX = 0;
  BUILD_KALDI = 0;
  BUILD_RNNT = 0;
  BUILD_CTC_DECODER = 0;

  preConfigure = lib.optionalString rocmSupport ''
    export ROCM_PATH=${rocmtoolkit_joined}
    export PYTORCH_ROCM_ARCH="${gpuTargetString}"
  '';

  dontUseCmakeConfigure = true;

  doCheck = false; # requires sox backend

  pythonImportsCheck = [ "torchaudio" ];

  meta = {
    description = "PyTorch audio library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/audio/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    platforms =
      lib.platforms.linux ++ lib.optionals (!cudaSupport && !rocmSupport) lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      GaetanLepage
      junjihashimoto
    ];
  };
}
