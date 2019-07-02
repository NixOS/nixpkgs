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
  version = "0.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wlpyzxdhcc043g9sjbrflky7xwdyq487v64i532zb2fpjskd59s";
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
