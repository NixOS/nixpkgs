{ lib, buildPythonPackage, fetchPypi, pandas, pytest }:

buildPythonPackage rec {
  pname = "vega_datasets";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fa672ba89ded093b30c6d59fce10aca3ac7c927df254e588da7b6d14f695181";
  };

  propagatedBuildInputs = [ pandas ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test vega_datasets --doctest-modules
  '';

  meta = with lib; {
    description = "A Python package for offline access to vega datasets";
    homepage = https://github.com/altair-viz/vega_datasets;
    license = licenses.mit;
  };
}
