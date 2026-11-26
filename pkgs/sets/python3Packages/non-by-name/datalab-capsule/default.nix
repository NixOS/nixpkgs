{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jsonschema,

  # optional-dependencies
  fastapi,
  uvicorn,
  numpy,

  # tests
  pytestCheckHook,
  h5py,
}:

buildPythonPackage (finalAttrs: {
  pname = "datalab-capsule";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DataLab-Platform";
    repo = "DataLab-Capsule";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cVQr5F+h+OSn72clCndZmokknyNcCt9O8gYuFj0eFrs=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    jsonschema
  ];

  optional-dependencies = {
    hdf5 = [
      h5py
      numpy
    ];
    registry = [
      fastapi
      uvicorn
    ];
  };

  pythonImportsCheck = [
    "datalab_capsule"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    h5py
  ];

  meta = {
    description = "Exchange and verify scientific workspace provenance as open RO-Crate capsules";
    homepage = "https://github.com/DataLab-Platform/DataLab-Capsule";
    changelog = "https://github.com/DataLab-Platform/DataLab-Capsule/releases/tag/${finalAttrs.src.rev}";
    mainProgram = "workspace-capsule";
    license = lib.licenses.bsd3;
    teams = with lib.teams; [ ngi ];
  };
})
