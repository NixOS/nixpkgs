{
  lib,
  stdenv,
  buildPythonPackage,
  python,
  fetchurl,
  pythonOlder,
  pythonAtLeast,

  # buildInputs
  cudaPackages,
  ffmpeg_6,
  sox,

  # nativeBuildInputs
  addDriverRunpath,
  autoPatchelfHook,

  # dependencies
  torch-bin,
}:

buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.5.1";
  format = "wheel";

  src =
    let
      pyVerNoDot = lib.replaceStrings [ "." ] [ "" ] python.pythonVersion;
      unsupported = throw "Unsupported system";
      srcs = (import ./binary-hashes.nix version)."${stdenv.system}-${pyVerNoDot}" or unsupported;
    in
    fetchurl srcs;

  disabled = (pythonOlder "3.9") || (pythonAtLeast "3.13");

  buildInputs =
    [
      # We need to patch lib/torio/_torio_ffmpeg6
      ffmpeg_6.dev
      sox
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux (
      with cudaPackages;
      [
        # $out/${sitePackages}/torchaudio/lib/libtorchaudio*.so wants libcudart.so.11.0 but torch/lib only ships
        # libcudart.$hash.so.11.0
        cuda_cudart

        # $out/${sitePackages}/torchaudio/lib/libtorchaudio*.so wants libnvToolsExt.so.2 but torch/lib only ships
        # libnvToolsExt-$hash.so.1
        cuda_nvtx
      ]
    );

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    addDriverRunpath
  ];

  dependencies = [ torch-bin ];

  preInstall = lib.optionals stdenv.hostPlatform.isLinux ''
    addAutoPatchelfSearchPath "${torch-bin}/${python.sitePackages}/torch"
  '';

  preFixup = ''
    # TorchAudio loads the newest FFmpeg that works, so get rid of the
    # old ones.
    rm $out/${python.sitePackages}/torio/lib/{lib,_}torio_ffmpeg{4,5}.*
  '';

  # The wheel-binary is not stripped to avoid the error of `ImportError: libtorch_cuda_cpp.so: ELF load command address/offset not properly aligned.`.
  dontStrip = true;

  pythonImportsCheck = [ "torchaudio" ];

  meta = {
    description = "PyTorch audio library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/audio/releases/tag/v${version}";
    # Includes CUDA and Intel MKL, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html
    license = lib.licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ junjihashimoto ];
  };
}
