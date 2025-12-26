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

  cudaPackages_12_6 =
    let
      inherit (cudaPackages_12_6.backendStdenv) hasJetsonCudaCapability;
    in
    mkCudaPackages {
      cublasmp = "0.6.0";
      cuda = "12.6.3";
      cudnn = "9.13.0";
      cudss = "0.6.0";
      cuquantum = "25.09.0";
      cusolvermp = "0.7.0";
      cusparselt = "0.6.3";
      cutensor = "2.3.1";
      nppplus = "0.10.0";
      nvcomp = "5.0.0.6";
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt = if hasJetsonCudaCapability then "10.7.0" else "10.14.1";
    };

  cudaPackages_12_8 =
    let
      inherit (cudaPackages_12_8.backendStdenv) hasJetsonCudaCapability;
    in
    mkCudaPackages {
      cublasmp = "0.6.0";
      cuda = "12.8.1";
      cudnn = "9.13.0";
      cudss = "0.6.0";
      cuquantum = "25.09.0";
      cusolvermp = "0.7.0";
      cusparselt = "0.8.1";
      cutensor = "2.3.1";
      nppplus = "0.10.0";
      nvcomp = "5.0.0.6";
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt = if hasJetsonCudaCapability then "10.7.0" else "10.14.1";
    };

  cudaPackages_12_9 =
    let
      inherit (cudaPackages_12_9.backendStdenv) hasJetsonCudaCapability;
    in
    mkCudaPackages {
      cublasmp = "0.6.0";
      cuda = "12.9.1";
      cudnn = "9.13.0";
      cudss = "0.6.0";
      cuquantum = "25.09.0";
      cusolvermp = "0.7.0";
      cusparselt = "0.8.1";
      cutensor = "2.3.1";
      nppplus = "0.10.0";
      nvcomp = "5.0.0.6";
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt = if hasJetsonCudaCapability then "10.7.0" else "10.14.1";
    };

  # NOTE: Thor is supported from CUDA 13.0, so our check needs to capture whether pre-Thor devices were selected.
  hasPreThorJetsonCudaCapability = lib.any (lib.flip lib.versionOlder "10.1");

  cudaPackages_13_0 =
    let
      inherit (cudaPackages_13_0.backendStdenv) requestedJetsonCudaCapabilities;
    in
    mkCudaPackages {
      cublasmp = "0.6.0";
      cuda = "13.0.2";
      cudnn = "9.13.0";
      cudss = "0.6.0";
      cuquantum = "25.09.0";
      cusolvermp = "0.7.0";
      cusparselt = "0.8.1";
      cutensor = "2.3.1";
      nppplus = "0.10.0";
      nvcomp = "5.0.0.6";
      nvjpeg2000 = "0.9.0";
      nvpl = "25.5";
      nvtiff = "0.5.1";
      tensorrt =
        if hasPreThorJetsonCudaCapability requestedJetsonCudaCapabilities then "10.7.0" else "10.14.1";
    };
in
{
  inherit
    cudaPackages_12_6
    cudaPackages_12_8
    cudaPackages_12_9
    cudaPackages_13_0
    ;
}
