{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  numba,
  numpy,
  scipy,

  # tests
  dask,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sparse";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydata";
    repo = "sparse";
    tag = version;
    hash = "sha256-ChSEb+IwzutDgYBJxhlunRaF8VvkLHW/ae5RdrljWj0=";
  };

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
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sparse" ];

  meta = {
    description = "Sparse n-dimensional arrays computations";
    homepage = "https://sparse.pydata.org/";
    changelog = "https://sparse.pydata.org/en/stable/changelog.html";
    downloadPage = "https://github.com/pydata/sparse/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
