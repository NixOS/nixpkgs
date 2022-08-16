{ lib
, buildPythonPackage
, fetchPypi
, python
, stdenv

# Propagated build inputs
, pytorch
, requests

# Python version
, pythonOlder
, pythonAtLeast
}:

let
  srcs = {
    "0.4.0" = {
      "x86_64-linux-310" = {
        platform = "manylinux2014_x86_64.whl";
        sha256 = "sha256-6zBYHZ/06t0/m4MMKfzMMqnhse1zJ3aRWXL7SM37VHE=";
      };
    };
    "0.4.1" = {
      "x86_64-linux-310" = {
        platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
        sha256 = "sha256-HclqlVhvmab8cki6LqEIqfbKVVqoDMWDC8NKcgHpLyY=";
      };
    };
  };
  pyVerNoDot = lib.replaceStrings [ "." ] [ "" ] python.pythonVersion;
  unsupported = throw "Unsupported system";
in
buildPythonPackage rec {
  pname = "torchdata";
  version = "0.3.0";
  format = "wheel";

  src =
    if version == "0.3.0" then
      fetchPypi {
        inherit pname version format;
        python = "py3";
        dist = "py3";
        sha256 = "sha256-vRb+N82aPcGWBQNVe11VYlHh8yuQeO2Ron3OUY6zKNY=";
      }
    else fetchPypi ({
      inherit pname version format;
      python = "cp${pyVerNoDot}";
      abi = if pyVerNoDot == "37" then "cp${pyVerNoDot}m" else "cp${pyVerNoDot}";
      dist = "cp${pyVerNoDot}";
    } // srcs.${version}."${stdenv.system}-${pyVerNoDot}" or unsupported);

  disabled = pythonOlder "3.7" || pythonAtLeast "3.11";

  propagatedBuildInputs = [
    pytorch
    requests
  ];

  pythonImportsCheck = [ "torchdata" ];

  meta = with lib; {
    description = "A PyTorch repo for data loading and utilities to be shared by the PyTorch domain libraries.";
    homepage = "github.com/pytorch/data";
    license = licenses.bsd3;
    maintainers = with maintainers; [  ];
  };
}
