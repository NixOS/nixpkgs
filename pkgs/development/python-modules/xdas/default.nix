{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  dask,
  h5netcdf,
  h5py,
  hdf5plugin,
  msgpack,
  numba,
  numpy,
  obspy,
  pandas,
  plotly,
  pyzmq,
  scipy,
  tqdm,
  watchdog,
  xarray,
  xinterp,
  black,
  isort,
  twine,
  ipykernel,
  matplotlib,
  myst-nb,
  pydata-sphinx-theme,
  sphinx,
  sphinx-copybutton,
  sphinx-design,
  pytest,
  pytest-cov,
  seisbench,
  torch,
}:

buildPythonPackage rec {
  pname = "xdas";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LQK2w2hn2rTq3UNjkgjAQzlPb4omZrM/x/uIWomKZcM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    dask
    h5netcdf
    h5py
    hdf5plugin
    msgpack
    numba
    numpy
    obspy
    pandas
    plotly
    pyzmq
    scipy
    tqdm
    watchdog
    xarray
    xinterp
  ];

  optional-dependencies = {
    dev = [
      black
      isort
      twine
    ];
    docs = [
      ipykernel
      matplotlib
      myst-nb
      pydata-sphinx-theme
      sphinx
      sphinx-copybutton
      sphinx-design
    ];
    tests = [
      pytest
      pytest-cov
      seisbench
      torch
    ];
  };

  pythonImportsCheck = [
    "xdas"
  ];

  meta = {
    description = "Managing, processing and visualizing Distributed Acoustic Sensing (DAS) data";
    homepage = "https://pypi.org/project/xdas";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bzizou ];
  };
}
