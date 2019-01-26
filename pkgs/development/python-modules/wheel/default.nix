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
  version = "0.32.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "029703bf514e16c8271c3821806a1c171220cc5bdd325cbf4e7da1e056a01db6";
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
