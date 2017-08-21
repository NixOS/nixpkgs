{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zxcvbn-python";
  version = "4.4.15";

  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef982a382518d217d353a42093aa8bb8608a50bc2df559c08885bba166782cd0";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Python implementation of Dropbox's realistic password strength estimator, zxcvbn";
    homepage = https://github.com/dwolfhub/zxcvbn-python;
    license = with lib.licenses; [ mit ];
  };
}