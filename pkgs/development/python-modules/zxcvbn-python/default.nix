{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zxcvbn-python";
  version = "4.4.22";

  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "402d4222dc9994baed66a19a1cf5cb5c3fafd065f9cabc4cf7d5a2915e980979";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Python implementation of Dropbox's realistic password strength estimator, zxcvbn";
    homepage = https://github.com/dwolfhub/zxcvbn-python;
    license = with lib.licenses; [ mit ];
  };
}