{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  fetchurl,
  pythonOlder,
  pythonAtLeast,

  # buildInputs
  cudaPackages,

  # nativeBuildInputs
  addDriverRunpath,
  autoPatchelfHook,

  # dependencies
  pillow,
  torch-bin,
}:

let
  pyVerNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  srcs = import ./binary-hashes.nix version;
  unsupported = throw "Unsupported system";
  version = "0.23.0";
in
buildPythonPackage {
  inherit version;

  pname = "torchvision";

  format = "wheel";

  src = fetchurl srcs."${stdenv.system}-${pyVerNoDot}" or unsupported;

  disabled = (pythonOlder "3.9") || (pythonAtLeast "3.14");

  # Note that we don't rely on config.cudaSupport here, because the Linux wheels all come built with CUDA support.
  buildInputs =
    with cudaPackages;
    lib.optionals stdenv.hostPlatform.isLinux [
      # $out/${sitePackages}/torchvision/_C.so wants libcudart.so.11.0 but torchvision.libs only ships
      # libcudart.$hash.so.11.0
      cuda_cudart
    ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    addDriverRunpath
    autoPatchelfHook
  ];

  dependencies = [
    pillow
    torch-bin
  ];

  # The wheel-binary is not stripped to avoid the error of `ImportError: libtorch_cuda_cpp.so: ELF load command address/offset not properly aligned.`.
  dontStrip = true;

  pythonImportsCheck = [ "torchvision" ];

  preInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    addAutoPatchelfSearchPath "${torch-bin}/${python.sitePackages}/torch"
  '';

  meta = {
    description = "PyTorch vision library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/vision/releases/tag/v${version}";
    # Includes CUDA and Intel MKL, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html
    license = lib.licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      GaetanLepage
      junjihashimoto
    ];
  };
}
