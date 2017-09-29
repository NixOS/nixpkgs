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
  version = "0.30.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9515fe0a94e823fd90b08d22de45d7bde57c90edce705b22f5e1ecf7e1b653c8";
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
