{ buildPythonPackage, colormath, fetchPypi, lib }:

buildPythonPackage rec {
  version = "0.0.11";
  pname = "spectra";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jrNipRh8tjzuE80BGGeZwMeRo6077FeyeRMuElIXYrg=";
  };
  doCheck = false;
  propagatedBuildInputs = [ colormath ];

  meta = with lib; {
    description = "Python library that makes color math, color scales, and color-space conversion easy";
    homepage = "https://github.com/jsvine/spectra";
    license = licenses.mit;
    maintainers = with maintainers; [ apraga ];
  };
}
