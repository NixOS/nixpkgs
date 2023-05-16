{ lib
, stdenv
, addOpenGLRunpath
, autoPatchelfHook
, buildPythonPackage
, cudaPackages
, fetchurl
, pythonAtLeast
, pythonOlder
, pillow
, python
, torch-bin
}:

let
  pyVerNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  srcs = import ./binary-hashes.nix version;
  unsupported = throw "Unsupported system";
<<<<<<< HEAD
  version = "0.15.2";
=======
  version = "0.15.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in buildPythonPackage {
  inherit version;

  pname = "torchvision";

  format = "wheel";

  src = fetchurl srcs."${stdenv.system}-${pyVerNoDot}" or unsupported;

  disabled = (pythonOlder "3.8") || (pythonAtLeast "3.12");

<<<<<<< HEAD
  # Note that we don't rely on config.cudaSupport here, because the Linux wheels all come built with CUDA support.
  buildInputs = with cudaPackages; lib.optionals stdenv.isLinux [
=======
  buildInputs = with cudaPackages; [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    # $out/${sitePackages}/torchvision/_C.so wants libcudart.so.11.0 but torchvision.libs only ships
    # libcudart.$hash.so.11.0
    cuda_cudart
  ];

<<<<<<< HEAD
  nativeBuildInputs = lib.optionals stdenv.isLinux [
=======
  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    autoPatchelfHook
    addOpenGLRunpath
  ];

  propagatedBuildInputs = [
    pillow
    torch-bin
  ];

  # The wheel-binary is not stripped to avoid the error of `ImportError: libtorch_cuda_cpp.so: ELF load command address/offset not properly aligned.`.
  dontStrip = true;

  pythonImportsCheck = [ "torchvision" ];

<<<<<<< HEAD
  preInstall = lib.optionalString stdenv.isLinux ''
=======
  preInstall = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    addAutoPatchelfSearchPath "${torch-bin}/${python.sitePackages}/torch"
  '';

  meta = with lib; {
    description = "PyTorch vision library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/vision/releases/tag/v${version}";
    # Includes CUDA and Intel MKL, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html
    license = licenses.bsd3;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
<<<<<<< HEAD
    platforms = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];
=======
    platforms = [ "x86_64-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
