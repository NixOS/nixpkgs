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
  version = "0.29.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ebb8ad7e26b448e9caa4773d2357849bf80ff9e313964bcaf79cbf0201a1648";
  };

  buildInputs = [ pytest pytestcov coverage ];

  propagatedBuildInputs = [ jsonschema ];

  # We add this flag to ignore the copy installed by bootstrapped-pip
  installFlags = [ "--ignore-installed" ];

  meta = {
    description = "A built-package format for Python";
    license = with lib.licenses; [ mit ];
    homepage = https://bitbucket.org/pypa/wheel/;
  };
}
