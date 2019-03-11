{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, numba
, pytest
}:

buildPythonPackage rec {
  pname = "sparse";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ac6fcbf68b38b999eae98467cf4880b942c13a72036868f78d65a10aeba808d";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [
    numpy
    scipy
    numba
  ];

  checkPhase = ''
    pytest sparse
  '';

  meta = with lib; {
    description = "Sparse n-dimensional arrays computations";
    homepage = https://github.com/pydata/sparse/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
