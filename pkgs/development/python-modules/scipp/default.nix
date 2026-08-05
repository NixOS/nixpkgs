{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  scikit-build-core,
  setuptools,
  setuptools-scm,

  # nativeBuildInputs
  cmake,
  ninja,

  # dependencies
  numpy,
  units-llnl,

  # buildInputs
  boost,
  eigen,
  gtest,
  pybind11,
  onetbb,

  # tests
  pytestCheckHook,
  scipy,
  beautifulsoup4,
  ipython,
  matplotlib,
  pandas,
  numba,
  xarray,
  h5py,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "scipp";
  version = "26.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "Scipp";
    tag = version;
    hash = "sha256-0IkLdkkqCw8qUKIh/ch9x1rbhKvAJAkjBSIz9y/GwSU=";
  };

  env = {
    SKIP_REMOTE_SOURCES = "true";
  };

  build-system = [
    scikit-build-core
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    numpy
  ];

  buildInputs = [
    boost
    eigen
    gtest
    pybind11
    units-llnl.passthru.top-level
    onetbb
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
    beautifulsoup4
    ipython
    matplotlib
    pandas
    numba
    xarray
    h5py
    hypothesis
  ];
  pytestFlags = [
    # See https://github.com/scipp/scipp/issues/3721
    "--hypothesis-profile=ci"
  ];

  pythonImportsCheck = [
    "scipp"
  ];

  meta = {
    description = "Multi-dimensional data arrays with labeled dimensions";
    homepage = "https://scipp.github.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
