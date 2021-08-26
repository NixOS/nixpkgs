{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, numba
, numpy
, scipy
  # Test Inputs
, pytestCheckHook
, dask
}:

buildPythonPackage rec {
  pname = "sparse";
  version = "0.12.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c95c3b8ee00211a5aa4ef5e46006d25bf35009a66e406b7ea9b25b327fb9516";
  };

  propagatedBuildInputs = [
    numba
    numpy
    scipy
  ];
  checkInputs = [ pytestCheckHook dask ];

  pythonImportsCheck = [ "sparse" ];

  meta = with lib; {
    description = "Sparse n-dimensional arrays computations";
    homepage = "https://sparse.pydata.org/en/stable/";
    changelog = "https://sparse.pydata.org/en/stable/changelog.html";
    downloadPage = "https://github.com/pydata/sparse/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
