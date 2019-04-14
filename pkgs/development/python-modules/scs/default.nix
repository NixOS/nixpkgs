{ buildPythonPackage, fetchPypi, lib, numpy, scipy }:

buildPythonPackage rec {
  pname = "scs";
  version = "2.1.0";

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m45366lfkv71mhdmr10ch7wgn16n79rg75jxqizqcgg6r5s6rqx";
  };

  meta = {
    description = "scs: splitting conic solver";
    homepage = https://github.com/cvxgrp/scs;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.teh ];
  };
}
