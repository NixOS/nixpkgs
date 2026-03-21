{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pkg-config,
  ninja,

  # buildInputs
  pybind11,
  sox,
  torch,
  llvmPackages,

  cudaSupport ? torch.cudaSupport,
  cudaPackages,
  rocmSupport ? torch.rocmSupport,
  rocmPackages,
}:

buildPythonPackage.override { stdenv = torch.stdenv; } (finalAttrs: {
  pname = "torchaudio";
  version = "2.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "audio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b1sjHVFXdNFDbdtXWSM2KisSRE/8IbzJI4rvzYQ4UMg=";
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
    BUILD_SOX = 0;
    BUILD_KALDI = 0;
    BUILD_RNNT = 0;
    BUILD_CTC_DECODER = 0;
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
    pybind11
    sox
    torch.cxxdev
  ]
  ++ lib.optionals torch.stdenv.cc.isClang [ llvmPackages.openmp ];

  dependencies = [ torch ];

  preConfigure = lib.optionalString rocmSupport ''
    export ROCM_PATH=${torch.rocmtoolkit_joined}
    export PYTORCH_ROCM_ARCH="${torch.gpuTargetString}"
  '';

  dontUseCmakeConfigure = true;

  doCheck = false; # requires sox backend

  pythonImportsCheck = [ "torchaudio" ];

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
