{ lib, buildPythonPackage, fetchPypi, pandas, pytest }:

buildPythonPackage rec {
  pname = "vega_datasets";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20d490b417f84607eb5079400f608f2e9c135b7092bee10f6857f6d23136e459";
  };

  propagatedBuildInputs = [ pandas ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test vega_datasets --doctest-modules -k 'not column_names'
  '';

  meta = with lib; {
    description = "A Python package for offline access to vega datasets";
    homepage = https://github.com/altair-viz/vega_datasets;
    license = licenses.mit;
  };
}
