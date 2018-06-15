{ lib
, buildPythonPackage
, fetchPypi
, pytest
, numpy
, pandas
, python
, fetchurl
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "0.10.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64c2d07b75b8ea1320cba521818a2f09107f5f46514d50ff5ef1c4d5da90aaf1";
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
