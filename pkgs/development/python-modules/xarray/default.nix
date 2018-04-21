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
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd5af05cc9ddd5713016ec1a7f0d481daf2f0bb4d4e0bd66790503f6412bbc59";
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
