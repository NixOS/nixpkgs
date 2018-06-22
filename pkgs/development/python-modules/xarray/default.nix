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
  version = "0.10.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d87241580e3eccb961dfc16e804e1b92b3d6a8000ffee82ceb076767934342cc";
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
