{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,

  # dependencies
  pooch,

  # tests
  geopandas,
  pyogrio,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "geodatasets";
  version = "2026.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geodatasets";
    tag = finalAttrs.version;
    hash = "sha256-TbDuFAJxaze/ehU3iuIPCRzlZsm6XwHokpawNtKU6EQ=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ pooch ];

  nativeCheckInputs = [
    geopandas
    pyogrio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTestMarks = [
    # disable tests which require network access
    "request"
  ];

  pythonImportsCheck = [ "geodatasets" ];

  meta = {
    description = "Spatial data examples";
    homepage = "https://geodatasets.readthedocs.io/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
})
