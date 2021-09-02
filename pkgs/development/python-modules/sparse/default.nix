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
  version = "0.13.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "685dc994aa770ee1b23f2d5392819c8429f27958771f8dceb2c4fb80210d5915";
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
