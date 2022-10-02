{ lib
, buildPythonPackage
, dask
, fetchPypi
, numba
, numpy
, pytestCheckHook
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "sparse";
  version = "0.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aF3JlKp3DuGyPy1TkoGchCnyeVh3H43OssT7gCENWRU=";
  };

  propagatedBuildInputs = [
    numba
    numpy
    scipy
  ];

  checkInputs = [
    dask
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sparse"
  ];

  meta = with lib; {
    description = "Sparse n-dimensional arrays computations";
    homepage = "https://sparse.pydata.org/";
    changelog = "https://sparse.pydata.org/en/stable/changelog.html";
    downloadPage = "https://github.com/pydata/sparse/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
