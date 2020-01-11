{ lib, buildPythonPackage, fetchPypi, pandas, pytest }:

buildPythonPackage rec {
  pname = "vega_datasets";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "db8883dab72b6f414e1fafdbf1e8db7543bba6ed77912a4e0c197d74fcfa1c20";
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
