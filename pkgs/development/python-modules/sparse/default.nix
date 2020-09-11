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
  version = "0.10.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ffbca00a53f938e4f04230f582b210440efb54d74d60af1d1ced3864f61677ac";
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
