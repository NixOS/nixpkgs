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
  version = "0.32.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "196c9842d79262bb66fcf59faa4bd0deb27da911dbc7c6cdca931080eb1f0783";
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
