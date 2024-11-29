{
  lib,
  buildPythonPackage,
  dask,
  fetchPypi,
  numba,
  numpy,
  pytest7CheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  scipy,
}:

buildPythonPackage rec {
  pname = "sparse";
  version = "0.15.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1LHFfST/D2Ty/VtalbSbf7hO0geibX1Yzidk3MXHK4Q=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "--cov-report term-missing --cov-report html --cov-report=xml --cov-report=term --cov sparse --cov-config .coveragerc --junitxml=junit/test-results.xml" ""
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

  pythonImportsCheck = [ "sparse" ];

  pytestFlagsArray = [
    "-W"
    "ignore::pytest.PytestRemovedIn8Warning"
  ];

  meta = with lib; {
    description = "Sparse n-dimensional arrays computations";
    homepage = "https://sparse.pydata.org/";
    changelog = "https://sparse.pydata.org/en/stable/changelog.html";
    downloadPage = "https://github.com/pydata/sparse/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
