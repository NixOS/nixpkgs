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
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wspvvp8hh9ar7pl6w1qhmakajsjsg4cm11pmi4a422jqmid0vw5";
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
