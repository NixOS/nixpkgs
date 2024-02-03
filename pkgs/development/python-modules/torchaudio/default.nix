{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, pkg-config
, ninja
, pybind11
, torch
, cudaSupport ? torch.cudaSupport
, cudaPackages
}:

buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "audio";
    rev = "v${version}";
    hash = "sha256-9lB4gLXq0nXHT1+DNOlbJQqNndt2I6kVoNwhMO/2qlE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'print(" --- Initializing submodules")' "return" \
      --replace "_fetch_archives(_parse_sources())" "pass"
  '';

  env = {
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" torch.cudaCapabilities}";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];
  buildInputs = [
    pybind11
  ] ++ lib.optionals cudaSupport [
    cudaPackages.libcurand.dev
    cudaPackages.libcurand.lib
    cudaPackages.cuda_cudart # cuda_runtime.h and libraries
    cudaPackages.cuda_cccl.dev # <thrust/*>
    cudaPackages.cuda_nvtx.dev
    cudaPackages.cuda_nvtx.lib # -llibNVToolsExt
    cudaPackages.libcublas.dev
    cudaPackages.libcublas.lib
    cudaPackages.libcufft.dev
    cudaPackages.libcufft.lib
  ];
  propagatedBuildInputs = [
    torch
  ];

  BUILD_SOX=0;
  BUILD_KALDI=0;
  BUILD_RNNT=0;
  BUILD_CTC_DECODER=0;

  dontUseCmakeConfigure = true;

  doCheck = false; # requires sox backend

  meta = with lib; {
    description = "PyTorch audio library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/audio/releases/tag/v${version}";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
