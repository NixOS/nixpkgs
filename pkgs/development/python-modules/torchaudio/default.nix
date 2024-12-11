{
  lib,
  symlinkJoin,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pkg-config,
  ninja,

  # buildInputs
  ffmpeg_6-full,
  pybind11,
  sox,
  torch,

  cudaSupport ? torch.cudaSupport,
  cudaPackages,
  rocmSupport ? torch.rocmSupport,
  rocmPackages,

  gpuTargets ? [ ],
}:

let
  # TODO: Reuse one defined in torch?
  # Some of those dependencies are probbly not required,
  # but it breaks when the store path is different between torch and torchaudio
  rocmtoolkit_joined = symlinkJoin {
    name = "rocm-merged";

    paths = with rocmPackages; [
      rocm-core
      clr
      rccl
      miopen
      miopengemm
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
      hipblas
      rocminfo
      rocm-thunk
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
  version = "2.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "audio";
    rev = "refs/tags/v${version}";
    hash = "sha256-BRn4EZ7bIujGA6b/tdMu9yDqJNEaf/f1Kj45aLHC/JI=";
  };

  patches = [ ./0001-setup.py-propagate-cmakeFlags.patch ];

  postPatch =
    ''
      substituteInPlace setup.py \
        --replace 'print(" --- Initializing submodules")' "return" \
        --replace "_fetch_archives(_parse_sources())" "pass"
    ''
    + lib.optionalString rocmSupport ''
      # There is no .info/version-dev, only .info/version
      substituteInPlace cmake/LoadHIP.cmake \
        --replace "/.info/version-dev" "/.info/version"
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

  nativeBuildInputs =
    [
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
  ];

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

  meta = {
    description = "PyTorch audio library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/audio/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ junjihashimoto ];
  };
}
