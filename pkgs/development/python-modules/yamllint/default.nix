{ lib, buildPythonPackage, fetchPypi
, nose, pyyaml, pathspec }:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.26.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-sOTImYXH9fhFHC64xn2ATRCsE6Sr4DHL9JvfNGXQEIc=";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [  pyyaml pathspec ];

  # Two test failures
  doCheck = false;

  meta = with lib; {
    description = "A linter for YAML files";
    homepage = "https://github.com/adrienverge/yamllint";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jonringer mikefaille ];
  };
}
