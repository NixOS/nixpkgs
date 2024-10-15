{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  fetchurl,

  # nativeBuildInputs
  addDriverRunpath,
  autoAddDriverRunpath,
  autoPatchelfHook,

  # buildInputs
  cudaPackages,

  # dependencies
  filelock,
  future,
  jinja2,
  networkx,
  numpy,
  pyyaml,
  requests,
  setuptools,
  sympy,
  typing-extensions,
  triton,

  callPackage,
}:

let
  pyVerNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  srcs = import ./binary-hashes.nix version;
  unsupported = throw "Unsupported system";
  version = "2.4.1";
in
buildPythonPackage {
  inherit version;

  pname = "torch";
  # Don't forget to update torch to the same version.

  format = "wheel";

  disabled = (pythonOlder "3.8") || (pythonAtLeast "3.13");

  src = fetchurl srcs."${stdenv.system}-${pyVerNoDot}" or unsupported;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    addDriverRunpath
    autoAddDriverRunpath
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux (
    with cudaPackages;
    [
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
    ]
  );

  autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.hostPlatform.isLinux [
    # This is the hardware-dependent userspace driver that comes from
    # nvidia_x11 package. It must be deployed at runtime in
    # /run/opengl-driver/lib or pointed at by LD_LIBRARY_PATH variable, rather
    # than pinned in runpath
    "libcuda.so.1"
  ];

  dependencies = [
    filelock
    future
    jinja2
    networkx
    numpy
    pyyaml
    requests
    setuptools
    sympy
    typing-extensions
  ] ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) [ triton ];

  postInstall = ''
    # ONNX conversion
    rm -rf $out/bin
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    addAutoPatchelfSearchPath "$out/${python.sitePackages}/torch/lib"
  '';

  # See https://github.com/NixOS/nixpkgs/issues/296179
  #
  # This is a quick hack to add `libnvrtc` to the runpath so that torch can find
  # it when it is needed at runtime.
  extraRunpaths = lib.optionals stdenv.hostPlatform.isLinux [
    "${lib.getLib cudaPackages.cuda_nvrtc}/lib"
  ];
  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "postPatchelfPhase" ];
  postPatchelfPhase = ''
    while IFS= read -r -d $'\0' elf ; do
      for extra in $extraRunpaths ; do
        echo patchelf "$elf" --add-rpath "$extra" >&2
        patchelf "$elf" --add-rpath "$extra"
      done
    done < <(
      find "''${!outputLib}" "$out" -type f -iname '*.so' -print0
    )
  '';

  # The wheel-binary is not stripped to avoid the error of `ImportError: libtorch_cuda_cpp.so: ELF load command address/offset not properly aligned.`.
  dontStrip = true;

  pythonImportsCheck = [ "torch" ];

  passthru.tests = callPackage ./tests.nix { };

  meta = {
    description = "PyTorch: Tensors and Dynamic neural networks in Python with strong GPU acceleration";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/pytorch/releases/tag/v${version}";
    # Includes CUDA and Intel MKL, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html
    # torch's license is BSD3.
    # torch-bin used to vendor CUDA. It still links against CUDA and MKL.
    license = with lib.licenses; [
      bsd3
      issl
      unfreeRedistributable
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    hydraPlatforms = [ ]; # output size 3.2G on 1.11.0
    maintainers = with lib.maintainers; [ junjihashimoto ];
  };
}
