{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zxcvbn-python";
  version = "4.4.16";

  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63cc481bfb8950c43d4a87926be22cf8c4bb281ef7f818a8ef2d30b55a97c3e0";
  };

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Python implementation of Dropbox's realistic password strength estimator, zxcvbn";
    homepage = https://github.com/dwolfhub/zxcvbn-python;
    license = with lib.licenses; [ mit ];
  };
}