{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  versioningit,
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
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    pname = "xnat";
    inherit version;
    hash = "sha256-YbZJl6lvhuhpmeC+0LikZghIEsR2OYe0Om6IRxZcBwg=";
  };

  build-system = [
    hatchling
    versioningit
  ];

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
    "pydicom"
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
