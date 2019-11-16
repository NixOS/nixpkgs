{ lib
, setuptools
, pip
, buildPythonPackage
, fetchFromGitHub
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

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = version;
    sha256 = "1bg4bxazsjxp621ymaykd8l75k7rvcvwawlipmjk7nsrl72l4p0s";
    name = "${pname}-${version}-source";
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
