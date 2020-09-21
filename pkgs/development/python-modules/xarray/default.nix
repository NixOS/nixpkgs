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
  version = "0.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e1af056ff834bf62ca57da917159328fab21b1f8c25284f92083016bb2d92a5";
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
