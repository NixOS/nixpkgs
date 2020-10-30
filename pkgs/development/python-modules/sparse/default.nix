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
  version = "0.11.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc5c35dbc81242237feb7a8e1f7d9c5e9dd9bb0910f6ec55f50dcc379082864f";
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
