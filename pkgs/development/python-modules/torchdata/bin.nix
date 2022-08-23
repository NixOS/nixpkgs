{ lib
, buildPythonPackage
, fetchurl
, python
, stdenv

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

  propagatedBuildInputs = [
    pytorch
    requests
    portalocker
    urllib3
  ];

  pythonImportsCheck = [ "torchdata" ];

  meta = with lib; {
    description = "A PyTorch repo for data loading and utilities to be shared by the PyTorch domain libraries.";
    homepage = "github.com/pytorch/data";
    license = licenses.bsd3;
    maintainers = with maintainers; [  ];
  };
}
