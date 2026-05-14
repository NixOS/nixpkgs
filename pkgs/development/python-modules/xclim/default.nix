{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit,
  setuptools,

  # dependencies
  boltons,
  bottleneck,
  cf-xarray,
  cftime,
  click,
  dask,
  filelock,
  jsonpickle,
  numba,
  packaging,
  pandas,
  pint,
  platformdirs,
  pooch,
  pyarrow,
  pyyaml,
  scikit-learn,
  scipy,
  statsmodels,
  xarray,
  yamale,

  # test
  versionCheckHook,
}:
buildPythonPackage rec {
  pname = "xclim";
  version = "0.60.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Ouranosinc";
    repo = "xclim";
    tag = "v${version}";
    hash = "sha256-dVa4/nvMg2iBW7j3eePZFggedLJXLF/4oU0k7zIp8d0=";
  };

  build-system = [
    flit
    setuptools
  ];

  dependencies = [
    boltons
    bottleneck
    cf-xarray
    cftime
    click
    dask
    filelock
    jsonpickle
    numba
    packaging
    pandas
    pint
    platformdirs
    pooch
    pyarrow
    pyyaml
    scikit-learn
    scipy
    statsmodels
    xarray
    yamale
  ];

  # No python test hooks has been added as all tests seems to be relying on network data
  # https://github.com/Ouranosinc/xclim/blob/e8ce9bf37083832517afb3375acc853191782d8f/tests/conftest.py#L314
  nativeCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

  pythonImportsCheck = [
    "xclim"
    "xclim.ensembles"
    "xclim.indices"
  ];

  meta = {
    description = "Operational Python library supporting climate services, based on xarray";
    homepage = "https://github.com/Ouranosinc/xclim";
    changelog = "https://github.com/Ouranosinc/xclim/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
    mainProgram = "xclim";
  };
}
