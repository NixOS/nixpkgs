{
  lib,
  stdenv,
  addDriverRunpath,
  cudaPackages,
  buildPythonPackage,
  fetchurl,
  isPy38,
  isPy39,
  isPy310,
  isPy311,
  python,
  autoPatchelfHook,
  filelock,
  lit,
  zlib,
}:

buildPythonPackage rec {
  pname = "triton";
  version = "2.1.0";
  format = "wheel";

  src =
    let
      pyVerNoDot = lib.replaceStrings [ "." ] [ "" ] python.pythonVersion;
      unsupported = throw "Unsupported system";
      srcs = (import ./binary-hashes.nix version)."${stdenv.system}-${pyVerNoDot}" or unsupported;
    in
    fetchurl srcs;

  disabled = !(isPy38 || isPy39 || isPy310 || isPy311);

  pythonRemoveDeps = [
    "cmake"
    # torch and triton refer to each other so this hook is included to mitigate that.
    "torch"
  ];

  buildInputs = [ zlib ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  propagatedBuildInputs = [
    filelock
    lit
    zlib
  ];

  dontStrip = true;

  # If this breaks, consider replacing with "${cuda_nvcc}/bin/ptxas"
  postFixup =
    ''
      chmod +x "$out/${python.sitePackages}/triton/third_party/cuda/bin/ptxas"
    ''
    + (
      let
        # Bash was getting weird without linting,
        # but basically upstream contains [cc, ..., "-lcuda", ...]
        # and we replace it with [..., "-lcuda", "-L/run/opengl-driver/lib", "-L$stubs", ...]
        old = [ "-lcuda" ];
        new = [
          "-lcuda"
          "-L${addDriverRunpath.driverLink}"
          "-L${cudaPackages.cuda_cudart}/lib/stubs/"
        ];

        quote = x: ''"${x}"'';
        oldStr = lib.concatMapStringsSep ", " quote old;
        newStr = lib.concatMapStringsSep ", " quote new;
      in
      ''
        substituteInPlace $out/${python.sitePackages}/triton/common/build.py \
          --replace '${oldStr}' '${newStr}'
      ''
    );

  meta = with lib; {
    description = "Language and compiler for custom Deep Learning operations";
    homepage = "https://github.com/triton-lang/triton/";
    changelog = "https://github.com/triton-lang/triton/releases/tag/v${version}";
    # Includes NVIDIA's ptxas, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # triton's license is MIT.
    # triton-bin includes ptxas binary, therefore unfreeRedistributable is set.
    license = with licenses; [
      unfreeRedistributable
      mit
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
