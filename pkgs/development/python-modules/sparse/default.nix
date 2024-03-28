{ lib
, buildPythonPackage
, dask
, fetchPypi
, numba
, numpy
, pytest7CheckHook
, pythonOlder
, setuptools
, setuptools-scm
, scipy
}:

buildPythonPackage rec {
  pname = "sparse";
  version = "0.15.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lzrcuIqNuOPYBHlTMx4m0/ZKVlf5tGprhZxHZjw+75k=";
  };

  postPatch = ''
    sed -i "/addopts =/d" pytest.ini
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numba
    numpy
    scipy
  ];

  nativeCheckInputs = [
    dask
    pytest7CheckHook
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
