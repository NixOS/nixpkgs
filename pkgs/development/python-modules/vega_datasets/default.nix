{ lib, buildPythonPackage, fetchPypi, pandas, pytest }:

buildPythonPackage rec {
  pname = "vega_datasets";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9dbe9834208e8ec32ab44970df315de9102861e4cda13d8e143aab7a80d93fc0";
  };

  propagatedBuildInputs = [ pandas ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test vega_datasets --doctest-modules -k 'not column_names'
  '';

  meta = with lib; {
    description = "A Python package for offline access to vega datasets";
    homepage = "https://github.com/altair-viz/vega_datasets";
    license = licenses.mit;
  };
}
