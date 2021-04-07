{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, dask
, numpy
, scipy
, numba
, pytest
}:

buildPythonPackage rec {
  pname = "sparse";
  version = "0.12.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c95c3b8ee00211a5aa4ef5e46006d25bf35009a66e406b7ea9b25b327fb9516";
  };

  checkInputs = [ pytest dask ];
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
    homepage = "https://github.com/pydata/sparse/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
