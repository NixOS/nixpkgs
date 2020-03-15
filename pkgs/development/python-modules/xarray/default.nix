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
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c72d160c970725201f769e80fb91cbad68d6ebf21d68fcc371385a6c950459c3";
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
