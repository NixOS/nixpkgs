{ lib
, setuptools
, pip
, buildPythonPackage
, fetchPypi
, pytest
, pytestcov
, coverage
, jsonschema
, bootstrapped-pip
}:

buildPythonPackage rec {
  pname = "wheel";
  version = "0.33.4";
  format = "other";

  src = fetchPypi {
    inherit pname version;
    sha256 = "62fcfa03d45b5b722539ccbc07b190e4bfff4bb9e3a4d470dd9f6a0981002565";
  };

  checkInputs = [ pytest pytestcov coverage ];
  nativeBuildInputs = [ bootstrapped-pip setuptools ];

  catchConflicts = false;
  # No tests in archive
  doCheck = false;

  # We add this flag to ignore the copy installed by bootstrapped-pip
  pipInstallFlags = [ "--ignore-installed" ];

  meta = {
    description = "A built-package format for Python";
    license = with lib.licenses; [ mit ];
    homepage = https://bitbucket.org/pypa/wheel/;
  };
}
