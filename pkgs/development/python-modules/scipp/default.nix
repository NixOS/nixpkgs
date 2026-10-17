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

let
  # https://github.com/scipp/scipp/blob/v26.9.0/pyproject.toml#L7-L10
  pybind11' = pybind11.overridePythonAttrs (old: {
    version = "3.0.4";
    src = old.src.override {
      hash = "sha256-QZKnIOopEDsiRFkc1qQ+DaDHoTNuEEgQVeiAL0sQqak=";
    };
  });
in
buildPythonPackage (finalAttrs: {
  pname = "scipp";
  version = "26.9.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "Scipp";
    tag = finalAttrs.version;
    hash = "sha256-1u9KT6o83hn9x/WGXj26OsGJOQpMBu1G4FiDIVaGXoM=";
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
    pybind11'
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
    changelog = "https://github.com/scipp/scipp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
