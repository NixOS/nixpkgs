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
  version = "25.05.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "Scipp";
    # https://github.com/scipp/scipp/pull/3722
    tag = version;
    hash = "sha256-AanXb+nF/YIZFuzG5UnoNPX97WScfPKuoSBY18uYt9k=";
  };
  env = {
    SKIP_CONAN = "true";
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
  pytestFlagsArray = [
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
    # Got:
    #
    #   error: a template argument list is expected after a name prefixed by the template keyword [-Wmissing-template-arg-list-after-template-kw]
    #
    # Needs debugging along with upstream.
    broken = stdenv.hostPlatform.isDarwin;
  };
}
