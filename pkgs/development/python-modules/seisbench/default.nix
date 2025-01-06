{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  bottleneck,
  h5py,
  nest-asyncio,
  numpy,
  obspy,
  pandas,
  scipy,
  torch,
  tqdm,
  black,
  flake8,
  isort,
  pre-commit,
  pytest,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "seisbench";
  version = "0.8.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q22w1eshAz9FtUE3OWuXQUWIcqLVSyyIFa998Ib1UWM=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [
    bottleneck
    h5py
    nest-asyncio
    numpy
    obspy
    pandas
    scipy
    torch
    tqdm
  ];

  optional-dependencies = {
    development = [
      black
      flake8
      isort
      pre-commit
    ];
    tests = [
      pytest
      pytest-asyncio
    ];
  };

  # Disabled because it tries to create a directory '/homeless-shelter/.seisbench'
  #pythonImportsCheck = [
  #  "seisbench"
  #];

  # Disable deps checking as we get a weird error with obspy:
  #    obspy>=1.3.1 not satisfied by version 0.0.0+archive
  dontCheckRuntimeDeps = true;

  meta = {
    description = "The seismological machine learning benchmark collection";
    homepage = "https://pypi.org/project/seisbench/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bzizou ];
  };
}
