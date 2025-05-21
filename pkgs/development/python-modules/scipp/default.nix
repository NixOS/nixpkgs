{
  lib,
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
  tbb_2022_0,

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
  version = "25.05.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "Scipp";
    tag = version;
    hash = "sha256-ZDvhhNuK4UGU8dGJ7rxn2RMw/zPWmhwIh5h3x1u0rMw=";
  };
  patches = [
    # https://github.com/scipp/scipp/pull/3704
    ./no-conan.patch
  ];
  env = {
    SKBUILD_CMAKE_ARGS = lib.strings.concatStringsSep ";" [
      (lib.cmakeBool "USE_CONAN" false)
    ];
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
    tbb_2022_0
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
