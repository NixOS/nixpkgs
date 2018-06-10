{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestcov
, coverage
, jsonschema
}:

buildPythonPackage rec {
  pname = "wheel";
  version = "0.31.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ae8153bed701cb062913b72429bcf854ba824f973735427681882a688cb55ce";
  };

  checkInputs = [ pytest pytestcov coverage ];

  propagatedBuildInputs = [ jsonschema ];

  # No tests in archive
  doCheck = false;

  # We add this flag to ignore the copy installed by bootstrapped-pip
  installFlags = [ "--ignore-installed" ];

  meta = {
    description = "A built-package format for Python";
    license = with lib.licenses; [ mit ];
    homepage = https://bitbucket.org/pypa/wheel/;
  };
}
