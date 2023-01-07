{ lib, stdenv
, buildPythonPackage
, fetchurl
, fetchpatch
, isPy37
, isPy38
, isPy39
, isPy310
, python
, addOpenGLRunpath
, future
, numpy
, patchelf
, pyyaml
, requests
, setuptools
, typing-extensions
, unzip
, zip
}:

let
  pyVerNoDot = builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  srcs = import ./binary-hashes.nix version;
  unsupported = throw "Unsupported system";
  version = "1.12.1";
in buildPythonPackage {
  inherit version;

  pname = "torch";
  # Don't forget to update torch to the same version.

  format = "wheel";

  disabled = !(isPy37 || isPy38 || isPy39 || isPy310);

  src = fetchurl srcs."${stdenv.system}-${pyVerNoDot}" or unsupported;

  patches = [
    (fetchpatch {
      name = "CVE-2022-45907.patch";
      url = "https://github.com/pytorch/pytorch/commit/74a9ca993bd79f8131829e9c946657fa9a1d05ef.patch";
      # luckily the fix itself is confined to a single
      # python file provided as source in the wheel, so
      # we can patch it despite this nominally being a
      # binary package
      includes = [ "torch/jit/annotations.py" ];
      sha256 = "sha256-KpLeuyF06hSeFeTncoYStIWsB8qv1b1X/ntPR59Xr1g=";
    })
  ];
  # extract wheel, run normal patch phase, repack wheel.
  # effectively a "wheelPatchPhase". not a normal thing
  # to do but needs must.
  patchPhase = ''
    wheelFile="$(realpath -s dist/*.whl)"
    pushd "$(mktemp -d)"

    unzip -q "$wheelFile"

    patchPhase

    newZip="$(mktemp -d)"/new.zip
    zip -rq "$newZip" *
    rm -rf "$wheelFile"
    cp "$newZip" "$wheelFile"

    popd
  '';

  nativeBuildInputs = [
    addOpenGLRunpath
    patchelf
    unzip
    zip
  ];

  propagatedBuildInputs = [
    future
    numpy
    pyyaml
    requests
    setuptools
    typing-extensions
  ];

  postInstall = ''
    # ONNX conversion
    rm -rf $out/bin
  '';

  postFixup = let
    rpath = lib.makeLibraryPath [ stdenv.cc.cc.lib ];
  in ''
    find $out/${python.sitePackages}/torch/lib -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      echo "setting rpath for $lib..."
      patchelf --set-rpath "${rpath}:$out/${python.sitePackages}/torch/lib" "$lib"
      addOpenGLRunpath "$lib"
    done
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
    license = licenses.bsd3;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux ++ platforms.darwin;
    hydraPlatforms = []; # output size 3.2G on 1.11.0
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
