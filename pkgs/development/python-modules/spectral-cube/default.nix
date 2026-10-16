{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
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

buildPythonPackage (finalAttrs: {
  pname = "spectral-cube";
  version = "0.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "radio-astro-tools";
    repo = "spectral-cube";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G/G3OtyhJ84KfnsmrOMK8Z6I/QTp8Wr8Fdo5R1CRnwU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

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

  disabledTestPaths = [
    # This test fails with "Passing a non-Collection iterable to parametrize is deprecated".
    "spectral_cube/tests/test_casafuncs.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # On x86_darwin, this test fails with "Fatal Python error: Aborted"
    # when sandbox = true.
    "spectral_cube/tests/test_visualization.py"
  ];

  pythonImportsCheck = [ "spectral_cube" ];

  meta = {
    description = "Library for reading and analyzing astrophysical spectral data cubes";
    homepage = "https://spectral-cube.readthedocs.io";
    changelog = "https://github.com/radio-astro-tools/spectral-cube/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ smaret ];
  };
})
