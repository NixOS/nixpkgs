{ lib, stdenv
, buildPythonPackage
, autoAddDriverRunpath
, fetchurl
, python
, pythonAtLeast
, pythonOlder
, addOpenGLRunpath
, cudaPackages
, future
, numpy
, autoPatchelfHook
, pyyaml
, requests
, setuptools
, typing-extensions
, sympy
, jinja2
, networkx
, filelock
, openai-triton
}:

let
  pyVerNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  srcs = import ./binary-hashes.nix version;
  unsupported = throw "Unsupported system";
  version = "2.3.0";
in buildPythonPackage {
  inherit version;

  pname = "torch";
  # Don't forget to update torch to the same version.

  format = "wheel";

  disabled = (pythonOlder "3.8") || (pythonAtLeast "3.13");

  src = fetchurl srcs."${stdenv.system}-${pyVerNoDot}" or unsupported;

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    addOpenGLRunpath
    autoPatchelfHook
    autoAddDriverRunpath
  ];

  buildInputs = lib.optionals stdenv.isLinux (with cudaPackages; [
    # $out/${sitePackages}/nvfuser/_C*.so wants libnvToolsExt.so.1 but torch/lib only ships
    # libnvToolsExt-$hash.so.1
    cuda_nvtx

    cuda_cudart
    cuda_cupti
    cuda_nvrtc
    cudnn
    libcublas
    libcufft
    libcurand
    libcusolver
    libcusparse
    nccl
  ]);

  autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.isLinux [
    # This is the hardware-dependent userspace driver that comes from
    # nvidia_x11 package. It must be deployed at runtime in
    # /run/opengl-driver/lib or pointed at by LD_LIBRARY_PATH variable, rather
    # than pinned in runpath
    "libcuda.so.1"
  ];

  propagatedBuildInputs = [
    future
    numpy
    pyyaml
    requests
    setuptools
    typing-extensions
    sympy
    jinja2
    networkx
    filelock
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isx86_64) [
    openai-triton
  ];

  postInstall = ''
    # ONNX conversion
    rm -rf $out/bin
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    addAutoPatchelfSearchPath "$out/${python.sitePackages}/torch/lib"
  '';

  # The wheel-binary is not stripped to avoid the error of `ImportError: libtorch_cuda_cpp.so: ELF load command address/offset not properly aligned.`.
  dontStrip = true;

  pythonImportsCheck = [ "torch" ];

  meta = with lib; {
    description = "PyTorch: Tensors and Dynamic neural networks in Python with strong GPU acceleration";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/pytorch/releases/tag/v${version}";
    # Includes CUDA and Intel MKL, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html
    # torch's license is BSD3.
    # torch-bin used to vendor CUDA. It still links against CUDA and MKL.
    license = with licenses; [ bsd3 issl unfreeRedistributable ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "aarch64-darwin" "aarch64-linux" "x86_64-linux" ];
    hydraPlatforms = []; # output size 3.2G on 1.11.0
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
