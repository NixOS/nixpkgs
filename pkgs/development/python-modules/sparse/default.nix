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

buildPythonPackage (finalAttrs: {
  pname = "sparse";
  version = "0.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydata";
    repo = "sparse";
    tag = finalAttrs.version;
    hash = "sha256-HHZ47TAgNbEEZj1sEe85yQRleW4Un2wfwQyFp4BPCbI=";
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
    downloadPage = "https://github.com/pydata/sparse/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
