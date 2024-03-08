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
  version = "0.15.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lzrcuIqNuOPYBHlTMx4m0/ZKVlf5tGprhZxHZjw+75k=";
  };

  propagatedBuildInputs = [
    numba
    numpy
    scipy
  ];

  nativeCheckInputs = [
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
    maintainers = with maintainers; [ ];
  };
}
