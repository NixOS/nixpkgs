{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  click,
  click-option-group,
  importlib-metadata,
  isodate,
  progressbar2,
  pydicom,
  python-dateutil,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "xnatpy";
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "xnat";
    inherit version;
    hash = "sha256-DVgDI6Jn6McPfS2WGDC+TDh06CQp46k4cd9ckjrLtsg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    click-option-group
    importlib-metadata
    isodate
    progressbar2
    pydicom
    python-dateutil
    pyyaml
    requests
  ];

  pythonRelaxDeps = [
    "importlib-metadata"
    "python-dateutil"
  ];

  # tests missing in PyPI dist and require network access and Docker container
  doCheck = false;

  pythonImportsCheck = [ "xnat" ];

  meta = {
    homepage = "https://xnat.readthedocs.io";
    description = "New XNAT client (distinct from pyxnat) that exposes XNAT objects/functions as Python objects/functions";
    changelog = "https://gitlab.com/radiology/infrastructure/xnatpy/-/blob/${version}/CHANGELOG?ref_type=tags";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "xnat";
  };
}
