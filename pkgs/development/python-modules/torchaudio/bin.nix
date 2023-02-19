{ lib
, stdenv
, buildPythonPackage
, fetchurl
, isPy37
, isPy38
, isPy39
, isPy310
, python
, torch-bin
, pythonOlder
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "torchaudio";
  version = "0.13.1";
  format = "wheel";

  src =
    let pyVerNoDot = lib.replaceStrings [ "." ] [ "" ] python.pythonVersion;
        unsupported = throw "Unsupported system";
        srcs = (import ./binary-hashes.nix version)."${stdenv.system}-${pyVerNoDot}" or unsupported;
    in fetchurl srcs;

  disabled = !(isPy37 || isPy38 || isPy39 || isPy310);

  propagatedBuildInputs = [
    torch-bin
  ];

  # The wheel-binary is not stripped to avoid the error of `ImportError: libtorch_cuda_cpp.so: ELF load command address/offset not properly aligned.`.
  dontStrip = true;

  pythonImportsCheck = [ "torchaudio" ];

  postFixup = ''
    # Note: after patchelf'ing, libcudart can still not be found. However, this should
    #       not be an issue, because PyTorch is loaded before torchvision and brings
    #       in the necessary symbols.
    patchelf --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}:${torch-bin}/${python.sitePackages}/torch/lib:" \
      "$out/${python.sitePackages}/torchaudio/_torchaudio.so"
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
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
