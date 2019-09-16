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
  version = "0.33.6";
  format = "other";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10c9da68765315ed98850f8e048347c3eb06dd81822dc2ab1d4fde9dc9702646";
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
