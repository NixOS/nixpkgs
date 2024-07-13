{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  click,
  isodate,
  progressbar2,
  pydicom,
  requests,
}:

buildPythonPackage rec {
  pname = "xnatpy";
  version = "0.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "xnat";
    inherit version;
    hash = "sha256-iOw9cVWP5Am4S9JQ0NTmtew38KZiKmau+19K2KG2aKQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    click
    isodate
    progressbar2
    pydicom
    requests
  ];

  # tests missing in PyPI dist and require network access and Docker container
  doCheck = false;

  pythonImportsCheck = [ "xnat" ];

  meta = with lib; {
    homepage = "https://xnat.readthedocs.io";
    description = "New XNAT client (distinct from pyxnat) that exposes XNAT objects/functions as Python objects/functions";
    changelog = "https://gitlab.com/radiology/infrastructure/xnatpy/-/blob/${version}/CHANGELOG?ref_type=tags";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "xnat";
  };
}
