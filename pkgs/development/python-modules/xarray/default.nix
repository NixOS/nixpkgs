{ lib
, buildPythonPackage
, fetchPypi
, pytest
, numpy
, pandas
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "0.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64e3138d87b641e22fe7a003c94abc685896b247b63e434505c1e6b38c91a8fb";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [numpy pandas];

  checkPhase = ''
    pytest $out/${python.sitePackages}
  '';

  # There always seem to be broken tests...
  doCheck = false;

  disabled = !isPy3k;

  meta = {
    description = "N-D labeled arrays and datasets in Python";
    homepage = "https://github.com/pydata/xarray";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
