{
  _cuda,
  callPackage,
  config,
  lib,
}:
let
  # NOTE: We cannot use backendStdenv.hostPlatform for the same reason we cannot use
  # backendStdenv.hasJetsonCudaCapability (see below).
  hostPlatform = callPackage ({ stdenv }: stdenv.hostPlatform) { };

  # NOTE: We cannot use backendStdenv.hasJetsonCudaCapability because backendStdenv asserts the requested capabilities
  # are supported by its CUDA version. Doing so would cause evaluation of every package set to fail when any package
  # set does not support the requested capabilities, since the manifests of each package set are compared against
  # those of the default package set. The default capabilities never include Jetson capabilities.
  hasJetsonCudaCapability = lib.any (
    cudaCapability: _cuda.db.cudaCapabilityToInfo.${cudaCapability}.isJetson or false
  ) (config.cudaCapabilities or [ ]);

  mkCudaPackages =
    manifestVersions:
    callPackage ../development/cuda-modules {
      manifests = _cuda.lib.selectManifests manifestVersions;
    };

  # NOTE:
  # The manifests are largely the same except for:
  # - TensorRT:
  #   - linux-x86_64 is generally the best supported and can use the latest release
  #   - linux-sbsa (server ARM, Jetson Thor, and Jetson Orin from CUDA 13.2) comes in second; NVIDIA dropped support for
  #     CUDA 12 with 10.13.2 (there is no 10.13.1), so we use 10.13.0 for all CUDA 12 releases.
  #   - linux-aarch64 (pre-Thor Jetson) is historically least supported; we use the latest release available.
  #   - TensorRT 11.x has no linux-sbsa build for CUDA 12 and dropped JetPack support with 11.2.1, so Jetson devices use
  #     TensorRT 10.x with CUDA 12 and CUDA 13.0 and 13.1, and TensorRT 11.1.0 (which supports Orin and Thor with
  #     CUDA 13.2 and later) with CUDA 13.2 and later.
  # - cudnn:
  #   - NVIDIA dropped linux-aarch64 (pre-Thor Jetson) support for CUDA 12 after 9.20.0, so we keep 9.20.0 for Jetson with
  #     CUDA 12, and use the latest release everywhere else.
  #   - Jetson Orin is supported with CUDA 13 only from CUDA 13.2, when it moved to linux-sbsa.
  # - cusparselt:
  #   - 0.7.0 requires CUDA 12.8 or newer, so we keep 0.6.3 for CUDA 12.6.
  #   - 0.8.x supports CUDA 12.9 and newer, so we keep 0.7.1 for CUDA 12.8.
  #   - NVIDIA dropped CUDA 12 support with 0.9.0, so we keep 0.8.1 for CUDA 12.9.

  cudaPackages_12_6 = mkCudaPackages {
    cublasmp = "0.10.0";
    cuda = "12.6.3";
    cudnn = if hasJetsonCudaCapability then "9.20.0" else "9.27.0";
    cudss = "0.8.0";
    cuquantum = "26.09.0";
    cusolvermp = "0.9.1";
    cusparselt = "0.6.3";
    cutensor = "2.8.1";
    nppplus = "0.10.0";
    nvcomp = "5.3.0";
    nvjpeg2000 = "0.11.0";
    nvpl = "26.5";
    nvtiff = "0.8.0";
    tensorrt =
      if hasJetsonCudaCapability then
        "10.7.0"
      else if hostPlatform.isAarch64 then
        "10.13.0"
      else
        "11.3.0";
  };

  cudaPackages_12_8 = mkCudaPackages {
    cublasmp = "0.10.0";
    cuda = "12.8.2";
    cudnn = if hasJetsonCudaCapability then "9.20.0" else "9.27.0";
    cudss = "0.8.0";
    cuquantum = "26.09.0";
    cusolvermp = "0.9.1";
    cusparselt = "0.7.1";
    cutensor = "2.8.1";
    nppplus = "0.10.0";
    nvcomp = "5.3.0";
    nvjpeg2000 = "0.11.0";
    nvpl = "26.5";
    nvtiff = "0.8.0";
    tensorrt =
      if hasJetsonCudaCapability then
        "10.7.0"
      else if hostPlatform.isAarch64 then
        "10.13.0"
      else
        "11.3.0";
  };

  cudaPackages_12_9 = mkCudaPackages {
    cublasmp = "0.10.0";
    cuda = "12.9.2";
    cudnn = if hasJetsonCudaCapability then "9.20.0" else "9.27.0";
    cudss = "0.8.0";
    cuquantum = "26.09.0";
    cusolvermp = "0.9.1";
    cusparselt = "0.8.1";
    cutensor = "2.8.1";
    nppplus = "0.10.0";
    nvcomp = "5.3.0";
    nvjpeg2000 = "0.11.0";
    nvpl = "26.5";
    nvtiff = "0.8.0";
    tensorrt =
      if hasJetsonCudaCapability then
        "10.7.0"
      else if hostPlatform.isAarch64 then
        "10.13.0"
      else
        "11.3.0";
  };

  cudaPackages_13_0 = mkCudaPackages {
    cublasmp = "0.10.0";
    cuda = "13.0.3";
    cudnn = "9.27.0";
    cudss = "0.8.0";
    cuquantum = "26.09.0";
    cusolvermp = "0.9.1";
    cusparselt = "0.10.0";
    cutensor = "2.8.1";
    nppplus = "0.10.0";
    nvcomp = "5.3.0";
    nvjpeg2000 = "0.11.0";
    nvpl = "26.5";
    nvtiff = "0.8.0";
    tensorrt = if hasJetsonCudaCapability then "10.16.1" else "11.3.0";
  };

  cudaPackages_13_1 = mkCudaPackages {
    cublasmp = "0.10.0";
    cuda = "13.1.2";
    cudnn = "9.27.0";
    cudss = "0.8.0";
    cuquantum = "26.09.0";
    cusolvermp = "0.9.1";
    cusparselt = "0.10.0";
    cutensor = "2.8.1";
    nppplus = "0.10.0";
    nvcomp = "5.3.0";
    nvjpeg2000 = "0.11.0";
    nvpl = "26.5";
    nvtiff = "0.8.0";
    tensorrt = if hasJetsonCudaCapability then "10.16.1" else "11.3.0";
  };

  cudaPackages_13_2 = mkCudaPackages {
    cublasmp = "0.10.0";
    cuda = "13.2.2";
    cudnn = "9.27.0";
    cudss = "0.8.0";
    cuquantum = "26.09.0";
    cusolvermp = "0.9.1";
    cusparselt = "0.10.0";
    cutensor = "2.8.1";
    nppplus = "0.10.0";
    nvcomp = "5.3.0";
    nvjpeg2000 = "0.11.0";
    nvpl = "26.5";
    nvtiff = "0.8.0";
    tensorrt = if hasJetsonCudaCapability then "11.1.0" else "11.3.0";
  };

  cudaPackages_13_3 = mkCudaPackages {
    cublasmp = "0.10.0";
    cuda = "13.3.1";
    cudnn = "9.27.0";
    cudss = "0.8.0";
    cuquantum = "26.09.0";
    cusolvermp = "0.9.1";
    cusparselt = "0.10.0";
    cutensor = "2.8.1";
    nppplus = "0.10.0";
    nvcomp = "5.3.0";
    nvjpeg2000 = "0.11.0";
    nvpl = "26.5";
    nvtiff = "0.8.0";
    tensorrt = if hasJetsonCudaCapability then "11.1.0" else "11.3.0";
  };

  cudaPackages_13_4 = mkCudaPackages {
    cublasmp = "0.10.0";
    cuda = "13.4.2";
    cudnn = "9.27.0";
    cudss = "0.8.0";
    cuquantum = "26.09.0";
    cusolvermp = "0.9.1";
    cusparselt = "0.10.0";
    cutensor = "2.8.1";
    nppplus = "0.10.0";
    nvcomp = "5.3.0";
    nvjpeg2000 = "0.11.0";
    nvpl = "26.5";
    nvtiff = "0.8.0";
    tensorrt = if hasJetsonCudaCapability then "11.1.0" else "11.3.0";
  };
in
{
  inherit
    cudaPackages_12_6
    cudaPackages_12_8
    cudaPackages_12_9
    cudaPackages_13_0
    cudaPackages_13_1
    cudaPackages_13_2
    cudaPackages_13_3
    cudaPackages_13_4
    ;
}
