{ lib
, stdenv
, addOpenGLRunpath
, autoPatchelfHook
, buildPythonPackage
, cudaPackages
, fetchurl
, ffmpeg_4
, ffmpeg_5
, ffmpeg_6
, sox
, pythonAtLeast
, pythonOlder
, python
, torch-bin
}:

buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.1.2";
  format = "wheel";

  src =
    let pyVerNoDot = lib.replaceStrings [ "." ] [ "" ] python.pythonVersion;
        unsupported = throw "Unsupported system";
        srcs = (import ./binary-hashes.nix version)."${stdenv.system}-${pyVerNoDot}" or unsupported;
    in
    fetchurl srcs;

  disabled = (pythonOlder "3.8") || (pythonAtLeast "3.12");

  buildInputs = with cudaPackages; [
    # $out/${sitePackages}/torchaudio/lib/libtorchaudio*.so wants libcudart.so.11.0 but torch/lib only ships
    # libcudart.$hash.so.11.0
    cuda_cudart

    # $out/${sitePackages}/torchaudio/lib/libtorchaudio*.so wants libnvToolsExt.so.2 but torch/lib only ships
    # libnvToolsExt-$hash.so.1
    cuda_nvtx

    # We need to patch the lib/_torchaudio_ffmpeg[4-6]
    ffmpeg_4.dev
    ffmpeg_5.dev
    ffmpeg_6.dev
    sox
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    addOpenGLRunpath
  ];

  propagatedBuildInputs = [
    torch-bin
  ];

  preInstall = ''
    addAutoPatchelfSearchPath "${torch-bin}/${python.sitePackages}/torch"
  '';

  # The wheel-binary is not stripped to avoid the error of `ImportError: libtorch_cuda_cpp.so: ELF load command address/offset not properly aligned.`.
  dontStrip = true;

  pythonImportsCheck = [ "torchaudio" ];

  meta = with lib; {
    description = "PyTorch audio library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/audio/releases/tag/v${version}";
    # Includes CUDA and Intel MKL, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html
    license = licenses.bsd3;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
