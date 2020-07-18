{ lib
, buildPythonPackage
, fetchPypi
, pytest
, numpy
, pandas
, python
, setuptools
, isPy3k
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1js3xr3fl9bwid8hl3w2pnigqzjd2rvkncald5x1x5fg7wjy8pb6";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy pandas setuptools ];

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
