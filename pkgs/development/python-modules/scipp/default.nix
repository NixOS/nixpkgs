{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  version = "26.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "Scipp";
    tag = version;
    hash = "sha256-Jbp7dOEAnXe9kBcYt35iC01i6FnZkFY5n9okGCeuuL4=";
  };

  patches = [
    # Fixes pytest deprecation failure:
    # https://github.com/scipp/scipp/pull/3907
    (fetchpatch {
      url = "https://github.com/scipp/scipp/commit/b3ad0c15e565737595f405b1d7bd1258b7bed422.patch";
      hash = "sha256-zxcZzuZMdm9WUKXPc8q2KkB+nCS8j+jZjfZAnLiGv6c=";
    })
    # Fixes Numpy related issue observed in tests:
    # https://github.com/scipp/scipp/pull/3920
    (fetchpatch {
      url = "https://github.com/scipp/scipp/commit/217b3baaf0696b12e39511d51a5d5270722ec48a.patch";
      hash = "sha256-jVzayIkJq93nwtmbpDQ5kcirtpLZqua6KRXY/eN3fQg=";
    })
  ];
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
