{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zxcvbn-python";
  version = "4.4.14";

  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd3a46536035851571e3f4142b64d6e7bcf0ade3cd40d8fecae7a1243945e327";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Python implementation of Dropbox's realistic password strength estimator, zxcvbn";
    homepage = https://github.com/dwolfhub/zxcvbn-python;
    license = with lib.licenses; [ mit ];
  };
}