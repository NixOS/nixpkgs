{
  lib,
  stdenv,
  cudaPackages,
  buildPythonPackage,
  fetchurl,
  glibc,
  python,
  autoPatchelfHook,
  zlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "triton";
  version = "3.6.0";
  format = "wheel";

  src =
    let
      pyVerNoDot = lib.replaceStrings [ "." ] [ "" ] python.pythonVersion;
      unsupported = throw "Unsupported system";
      srcs =
        (import ./binary-hashes.nix finalAttrs.version)."${stdenv.system}-${pyVerNoDot}" or unsupported;
    in
    fetchurl srcs;

  buildInputs = [ zlib ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  dontStrip = true;

  postFixup =
    # If this breaks, consider replacing with "${cuda_nvcc}/bin/ptxas"
    ''
      mkdir -p $out/${python.sitePackages}/triton/third_party/cuda/bin/
      ln -s ${cudaPackages.cuda_nvcc}/bin/ptxas $out/${python.sitePackages}/triton/third_party/cuda/bin/
    ''
    # FileNotFoundError: [Errno 2] No such file or directory: '/sbin/ldconfig'
    + ''
      BACKENDS_DIR="$out/${python.sitePackages}/triton/backends"
      substituteInPlace \
        $BACKENDS_DIR/amd/driver.py \
        $BACKENDS_DIR/nvidia/driver.py \
        --replace-fail "/sbin/ldconfig" "${lib.getExe' glibc "ldconfig"}"
    '';

  meta = {
    description = "Language and compiler for custom Deep Learning operations";
    homepage = "https://github.com/triton-lang/triton/";
    changelog = "https://github.com/triton-lang/triton/releases/tag/v${finalAttrs.version}";
    # Includes NVIDIA's ptxas, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # triton's license is MIT.
    # triton-bin includes ptxas binary, therefore unfreeRedistributable is set.
    license = with lib.licenses; [
      unfreeRedistributable
      mit
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      GaetanLepage
      junjihashimoto
    ];
  };
})
