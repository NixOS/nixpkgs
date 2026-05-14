{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependenices
  numpy,
  packaging,
  pandas,

  # optional-dependencies
  bottleneck,
  cartopy,
  cftime,
  dask,
  fsspec,
  h5netcdf,
  matplotlib,
  netcdf4,
  numba,
  numbagg,
  opt-einsum,
  pooch,
  scipy,
  seaborn,
  sparse,
  zarr,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  h5py,
}:

buildPythonPackage (finalAttrs: {
  pname = "xarray";
  version = "2026.04.0";
  pyproject = true;
  # Needed mainly for pytestFlags with spaces
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pydata";
    repo = "xarray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BsgL+Xo9fTMLLdz5AfScnKGuBa76cE85LuUzB4ZNLiY=";
  };

  postPatch = ''
    # don't depend on pytest-mypy-plugins
    sed -i "/--mypy-/d" pyproject.toml
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
    packaging
    pandas
  ];

  optional-dependencies = {
    accel = [
      bottleneck
      # flox
      numba
      numbagg
      opt-einsum
      scipy
    ];
    io = [
      netcdf4
      h5netcdf
      # pydap
      scipy
      zarr
      fsspec
      cftime
      pooch
    ];
    etc = [ sparse ];
    parallel = [ dask ] ++ dask.optional-dependencies.complete;
    viz = [
      cartopy
      matplotlib
      # nc-time-axis
      seaborn
    ];
    complete =
      with finalAttrs.finalPackage.passthru.optional-dependencies;
      accel ++ io ++ etc ++ parallel ++ viz;
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  # Besides scipy, these are not strictly needed for the tests, but adding all
  # of these optional-dependencies extends the amount of tests from ~17k to
  # ~21k.
  ++ finalAttrs.finalPackage.optional-dependencies.io
  ++ finalAttrs.finalPackage.optional-dependencies.accel
  ++ finalAttrs.finalPackage.optional-dependencies.etc
  ++ finalAttrs.finalPackage.optional-dependencies.parallel
  # Not adding optional-dependencies.viz because adding cartopy causes infinite
  # recursion, and doesn't cause more tests to be collected.
  ;
  pytestFlags = lib.optionals (!h5py.hdf5.szipSupport) [
    "-k"
    # Our h5py is built with hdf5 that is built without szip support, so we
    # skip these tests
    "not szip"
  ];

  pythonImportsCheck = [ "xarray" ];

  meta = {
    changelog = "https://github.com/pydata/xarray/blob/${finalAttrs.src.tag}/doc/whats-new.rst";
    description = "N-D labeled arrays and datasets in Python";
    homepage = "https://github.com/pydata/xarray";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      doronbehar
    ];
  };
})
