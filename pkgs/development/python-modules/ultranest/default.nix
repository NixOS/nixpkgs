{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,

  # dependencies
  corner,
  h5py,
  matplotlib,
  scipy,
  six,

  # tests
  pandas,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ultranest";
  version = "4.6.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "JohannesBuchner";
    repo = "UltraNest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uJxY2npTmmN6Xn9K6H3JmBMiYQBdqZrvO70Pc6OnUrU=";
  };

  build-system = [
    cython
    numpy
    setuptools
  ];

  # Only needed at build time
  pythonRemoveDeps = [ "cython" ];
  dependencies = [
    corner
    h5py
    matplotlib
    numpy
    scipy
    six
  ];

  pythonImportsCheck = [ "ultranest" ];

  nativeCheckInputs = [
    pandas
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf ultranest
    export MPLBACKEND=Agg
  '';

  pytestFlags = [
    "-o"
    "addopts="
  ];

  disabledTests = [
    # ModuleNotFoundError: No module named 'getdist'
    "test_hdi"
  ];

  disabledTestPaths = [
    # Requires torch and joblib (optional simulation-based inference helpers)
    "tests/test_minisbi.py"
  ];

  meta = {
    description = "Fit and compare complex models reliably and rapidly with advanced nested sampling";
    homepage = "https://github.com/JohannesBuchner/UltraNest";
    changelog = "https://github.com/JohannesBuchner/UltraNest/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
