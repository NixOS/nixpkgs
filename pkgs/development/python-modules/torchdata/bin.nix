{ lib
, buildPythonPackage
, fetchurl
, python
, stdenv

# Native build inputs
, patchelf

# Propagated build inputs
, portalocker
, pytorch
, requests
, urllib3
, zlib

# Python version
, pythonOlder
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "torchdata";
  version = "0.4.1";
  format = "wheel";

  src =
    let
      pyVerNoDot = lib.replaceStrings [ "." ] [ "" ] python.pythonVersion;
      unsupported = throw "Unsupported system ${stdenv.system}-${pyVerNoDot}";
      srcUrl = (import ./binary-hashes.nix version)."${stdenv.system}-${pyVerNoDot}" or unsupported;
    in
      fetchurl srcUrl;

  disabled = pythonOlder "3.7" || pythonAtLeast "3.11";

  nativeBuildInputs = [
    patchelf
  ];

  propagatedBuildInputs = [
    pytorch
    requests
    portalocker
    urllib3
  ];

  postFixup = let
    rpath = lib.makeLibraryPath [ zlib ];
  in ''
    find $out/${python.sitePackages}/torchdata -type f \( -name '*.so' -or -name '*.so.*' \) | while read lib; do
      echo "setting rpath for $lib..."
      patchelf --set-rpath "${rpath}:$out/${python.sitePackages}/torch/lib" "$lib"
    done
  '';


  pythonImportsCheck = [ "torchdata" ];

  meta = with lib; {
    description = "A PyTorch repo for data loading and utilities to be shared by the PyTorch domain libraries.";
    homepage = "github.com/pytorch/data";
    license = licenses.bsd3;
    maintainers = with maintainers; [  ];
  };
}
