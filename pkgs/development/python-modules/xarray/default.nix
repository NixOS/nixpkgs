{ lib
, buildPythonPackage
, fetchPypi
, pytest
, numpy
, pandas
, python
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "0.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pc4p7yxvmhn3x121wgslwclaqnjlx51wxs6ihb4cxynh2vcwgfc";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [numpy pandas];

  checkPhase = ''
    py.test $out/${python.sitePackages}
  '';

  # There always seem to be broken tests...
  doCheck = false;

  meta = {
    description = "N-D labeled arrays and datasets in Python";
    homepage = https://github.com/pydata/xarray;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
