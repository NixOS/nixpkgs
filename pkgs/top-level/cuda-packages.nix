{
  _cuda,
  callPackage,
  config,
  lib,
}:
let
  mkCudaPackages =
    manifestVersions:
    callPackage ../development/cuda-modules {
      manifests = _cuda.lib.selectManifests manifestVersions;
    };

  # NOTE:
  # The manifests are largely the same except for:
  # - TensorRT:
  #   - linux-x86_64 is generally the best supported and can use the latest release
  #   - linux-sbsa (post-Orin Jetson and ARM) comes in second; NVIDIA dropped support for CUDA 12 with 10.13.2 (there is no
  #     10.13.1), so we use 10.13.0 for all CUDA 12 releases.
  #   - linux-aarch64 (pre-Thor Jetson) is historically least supported; we use the latest release available.
  # - cudnn:
  #   - NVIDIA dropped linux-aarch64 (pre-Thor Jetson) support for CUDA 13 after 9.14.0 and for CUDA 12 after 9.20.0,
  #     so we keep 9.20.0 for Jetson with CUDA 12, 9.13.0 for pre-Thor Jetson with CUDA 13, and use the latest
  #     release everywhere else.
  # - cusparselt:
  #   - 0.7.0 requires CUDA 12.8 or newer, so we keep 0.6.3 for CUDA 12.6.
  #   - NVIDIA dropped CUDA 12 support with 0.9.0, so we keep 0.8.1 for CUDA 12.8 and 12.9.

  cudaPackages_12_6 =
    let
      inherit (cudaPackages_12_6.backendStdenv) hasJetsonCudaCapability hostPlatform;
    in
    mkCudaPackages {
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
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt =
        if hasJetsonCudaCapability then
          "10.7.0"
        else if hostPlatform.isAarch64 then
          "10.13.0"
        else
          "10.16.1";
    };

  cudaPackages_12_8 =
    let
      inherit (cudaPackages_12_8.backendStdenv) hasJetsonCudaCapability hostPlatform;
    in
    mkCudaPackages {
      cublasmp = "0.10.0";
      cuda = "12.8.2";
      cudnn = if hasJetsonCudaCapability then "9.20.0" else "9.27.0";
      cudss = "0.8.0";
      cuquantum = "26.09.0";
      cusolvermp = "0.9.1";
      cusparselt = "0.8.1";
      cutensor = "2.8.1";
      nppplus = "0.10.0";
      nvcomp = "5.3.0";
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt =
        if hasJetsonCudaCapability then
          "10.7.0"
        else if hostPlatform.isAarch64 then
          "10.13.0"
        else
          "10.16.1";
    };

  cudaPackages_12_9 =
    let
      inherit (cudaPackages_12_9.backendStdenv) hasJetsonCudaCapability hostPlatform;
    in
    mkCudaPackages {
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
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt =
        if hasJetsonCudaCapability then
          "10.7.0"
        else if hostPlatform.isAarch64 then
          "10.13.0"
        else
          "10.16.1";
    };

  # NOTE: Thor is supported from CUDA 13.0, so our check needs to capture whether pre-Thor devices were selected.
  hasPreThorJetsonCudaCapability = lib.any (lib.flip lib.versionOlder "10.1");

  cudaPackages_13_0 =
    let
      inherit (cudaPackages_13_0.backendStdenv) requestedJetsonCudaCapabilities;
    in
    mkCudaPackages {
      cublasmp = "0.10.0";
      cuda = "13.0.3";
      cudnn =
        if hasPreThorJetsonCudaCapability requestedJetsonCudaCapabilities then "9.13.0" else "9.27.0";
      cudss = "0.8.0";
      cuquantum = "26.09.0";
      cusolvermp = "0.9.1";
      cusparselt = "0.10.0";
      cutensor = "2.8.1";
      nppplus = "0.10.0";
      nvcomp = "5.3.0";
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt =
        if hasPreThorJetsonCudaCapability requestedJetsonCudaCapabilities then "10.7.0" else "10.16.1";
    };

  cudaPackages_13_1 =
    let
      inherit (cudaPackages_13_1.backendStdenv) requestedJetsonCudaCapabilities;
    in
    mkCudaPackages {
      cublasmp = "0.10.0";
      cuda = "13.1.2";
      cudnn =
        if hasPreThorJetsonCudaCapability requestedJetsonCudaCapabilities then "9.13.0" else "9.27.0";
      cudss = "0.8.0";
      cuquantum = "26.09.0";
      cusolvermp = "0.9.1";
      cusparselt = "0.10.0";
      cutensor = "2.8.1";
      nppplus = "0.10.0";
      nvcomp = "5.3.0";
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt =
        if hasPreThorJetsonCudaCapability requestedJetsonCudaCapabilities then "10.7.0" else "10.16.1";
    };

  cudaPackages_13_2 =
    let
      inherit (cudaPackages_13_2.backendStdenv) requestedJetsonCudaCapabilities;
    in
    mkCudaPackages {
      cublasmp = "0.10.0";
      cuda = "13.2.2";
      cudnn =
        if hasPreThorJetsonCudaCapability requestedJetsonCudaCapabilities then "9.13.0" else "9.27.0";
      cudss = "0.8.0";
      cuquantum = "26.09.0";
      cusolvermp = "0.9.1";
      cusparselt = "0.10.0";
      cutensor = "2.8.1";
      nppplus = "0.10.0";
      nvcomp = "5.3.0";
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt =
        if hasPreThorJetsonCudaCapability requestedJetsonCudaCapabilities then "10.7.0" else "10.16.1";
    };

  cudaPackages_13_3 =
    let
      inherit (cudaPackages_13_3.backendStdenv) requestedJetsonCudaCapabilities;
    in
    mkCudaPackages {
      cublasmp = "0.10.0";
      cuda = "13.3.1";
      cudnn =
        if hasPreThorJetsonCudaCapability requestedJetsonCudaCapabilities then "9.13.0" else "9.27.0";
      cudss = "0.8.0";
      cuquantum = "26.09.0";
      cusolvermp = "0.9.1";
      cusparselt = "0.10.0";
      cutensor = "2.8.1";
      nppplus = "0.10.0";
      nvcomp = "5.3.0";
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt =
        if hasPreThorJetsonCudaCapability requestedJetsonCudaCapabilities then "10.7.0" else "10.16.1";
    };

  cudaPackages_13_4 =
    let
      inherit (cudaPackages_13_4.backendStdenv) requestedJetsonCudaCapabilities;
    in
    mkCudaPackages {
      cublasmp = "0.10.0";
      cuda = "13.4.2";
      cudnn =
        if hasPreThorJetsonCudaCapability requestedJetsonCudaCapabilities then "9.13.0" else "9.27.0";
      cudss = "0.8.0";
      cuquantum = "26.09.0";
      cusolvermp = "0.9.1";
      cusparselt = "0.10.0";
      cutensor = "2.8.1";
      nppplus = "0.10.0";
      nvcomp = "5.3.0";
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt =
        if hasPreThorJetsonCudaCapability requestedJetsonCudaCapabilities then "10.7.0" else "10.16.1";
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
