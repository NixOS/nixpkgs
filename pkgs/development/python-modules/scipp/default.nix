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
<<<<<<< HEAD
  version = "25.12.0";
=======
  version = "25.11.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipp";
    repo = "Scipp";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-Gv5Lgufsj5kCtOC+zTgeWTwwYm8j2Ct8cTK1RJ5+XDg=";
=======
    hash = "sha256-/gCLWRpBnOjNMBEpJe0JSda496iXDFnCE+R+zIaRkWo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    # Got:
    #
    #   error: a template argument list is expected after a name prefixed by the template keyword [-Wmissing-template-arg-list-after-template-kw]
    #
    # Needs debugging along with upstream.
    broken = stdenv.hostPlatform.isDarwin;
  };
}
