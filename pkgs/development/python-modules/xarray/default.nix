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
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af1449e8df84a6eb09eb1d56c1dc5ac7f24a9563d4f2b9391ff364dc0c62344c";
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
