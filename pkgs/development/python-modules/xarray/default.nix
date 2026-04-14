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
}:

buildPythonPackage rec {
  pname = "xarray";
  version = "2026.04.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydata";
    repo = "xarray";
    tag = "v${version}";
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

  optional-dependencies = lib.fix (self: {
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
    complete = with self; accel ++ io ++ etc ++ parallel ++ viz;
  });

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    scipy
  ];

  pythonImportsCheck = [ "xarray" ];

  meta = {
    changelog = "https://github.com/pydata/xarray/blob/${src.tag}/doc/whats-new.rst";
    description = "N-D labeled arrays and datasets in Python";
    homepage = "https://github.com/pydata/xarray";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      doronbehar
    ];
  };
}
