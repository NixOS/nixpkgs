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
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a8b93e1b0af27fa7de199a2d36933f1f5acc9854783646b0f1b37fed9b4da091";
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
    homepage = https://github.com/pydata/xarray;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
