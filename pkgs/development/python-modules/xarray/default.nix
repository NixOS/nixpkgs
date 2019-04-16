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
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac09a819e791be208ae33fa7ecee19d0fe7b5479906f927d358a61957ce27e10";
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
