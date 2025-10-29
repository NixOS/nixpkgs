{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  astropy,
  casa-formats-io,
  dask,
  joblib,
  numpy,
  packaging,
  radio-beam,
  tqdm,

  # tests
  aplpy,
  pytest-astropy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spectral-cube";
  version = "0.6.6-unstable-2025-06-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "radio-astro-tools";
    repo = "spectral-cube";
    # tag = "v${version}";
    # Unreleased PR with several build and test fixes: https://github.com/radio-astro-tools/spectral-cube/pull/951
    rev = "f95ba1ca1823758d340ce0bfd3181ae3bc041b93";
    hash = "sha256-LUWdxA7gfZI2MDpKuk+DiEJtXyWeS8co+3tZt97Uh3w=";
  };

  # remove after update to 0.6.7
  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.6.6";

  build-system = [ setuptools-scm ];

  dependencies = [
    astropy
    casa-formats-io
    dask
    joblib
    numpy
    packaging
    radio-beam
    tqdm
  ]
  ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    aplpy
    pytest-astropy
    pytestCheckHook
  ];

  # Tests must be run in the build directory.
  preCheck = ''
    cd build/lib
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky: AssertionError: assert diffvals.max()*u.B <= 1*u.MB
    "test_reproject_3D_memory"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # On x86_darwin, this test fails with "Fatal Python error: Aborted"
    # when sandbox = true.
    "spectral_cube/tests/test_visualization.py"
  ];

  pythonImportsCheck = [ "spectral_cube" ];

  meta = {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = "https://spectral-cube.readthedocs.io";
    changelog = "https://github.com/radio-astro-tools/spectral-cube/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ smaret ];
  };
}
