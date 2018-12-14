{ lib, buildPythonPackage, fetchPypi, pandas, pytest }:

buildPythonPackage rec {
  pname = "vega_datasets";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02zk5d65g58kpmgbbng47fg357yizv25z8nzi95nvw6vp6y2b3d3";
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
