{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zxcvbn-python";
  version = "4.4.24";


  src = fetchPypi {
    inherit pname version;
    sha256 = "900b28cc5e96be4091d8778f19f222832890264e338765a1c1c09fca2db64b2d";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Python implementation of Dropbox's realistic password strength estimator, zxcvbn";
    homepage = https://github.com/dwolfhub/zxcvbn-python;
    license = with lib.licenses; [ mit ];
  };
}