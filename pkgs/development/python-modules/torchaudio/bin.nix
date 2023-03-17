{ lib
, stdenv
, buildPythonPackage
, fetchurl
, isPy37
, isPy38
, isPy39
, isPy310
, isPy311
, python
, torch-bin
, pythonOlder
, pythonAtLeast
, patchelf
, addOpenGLRunpath
}:

buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.0.1";
  format = "wheel";

  src =
    let pyVerNoDot = lib.replaceStrings [ "." ] [ "" ] python.pythonVersion;
        unsupported = throw "Unsupported system";
        srcs = (import ./binary-hashes.nix version)."${stdenv.system}-${pyVerNoDot}" or unsupported;
    in fetchurl srcs;

  disabled = !(isPy38 || isPy39 || isPy310 || isPy311);

  nativeBuildInputs = [
    patchelf
    addOpenGLRunpath
  ];

  propagatedBuildInputs = [
    torch-bin
  ];

  # The wheel-binary is not stripped to avoid the error of `ImportError: libtorch_cuda_cpp.so: ELF load command address/offset not properly aligned.`.
  dontStrip = true;

  pythonImportsCheck = [ "torchaudio" ];

  postFixup = let
    rpath = lib.makeLibraryPath [ stdenv.cc.cc.lib ];
  in ''
    find $out/${python.sitePackages}/torchaudio/lib -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      echo "setting rpath for $lib..."
      patchelf --set-rpath "${rpath}:$out/${python.sitePackages}/torchaudio/lib" "$lib"
      addOpenGLRunpath "$lib"
    done
  '';

  meta = with lib; {
    description = "PyTorch audio library";
    homepage = "https://pytorch.org/";
    changelog = "https://github.com/pytorch/audio/releases/tag/v${version}";
    # Includes CUDA and Intel MKL, but redistributions of the binary are not limited.
    # https://docs.nvidia.com/cuda/eula/index.html
    # https://www.intel.com/content/www/us/en/developer/articles/license/onemkl-license-faq.html
    license = licenses.bsd3;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
