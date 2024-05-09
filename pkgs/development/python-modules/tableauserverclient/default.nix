{ lib
, buildPythonPackage
, defusedxml
, fetchPypi
, packaging
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, requests
, requests-mock
, setuptools
, versioneer
}:

buildPythonPackage rec {
  pname = "tableauserverclient";
  version = "0.30";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MIE6V84xLEbgmTwvP6jQC0H//gBnMTO1sowL1HIMbpQ=";
  };

  postPatch = ''
    # Remove vendorized versioneer
    rm versioneer.py
  '';

  pythonRelaxDeps = [
    "urllib3"
  ];

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
    versioneer
  ];

  propagatedBuildInputs = [
    defusedxml
    requests
    packaging
  ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  # Tests attempt to create some file artifacts and fails
  doCheck = false;

  pythonImportsCheck = [
    "tableauserverclient"
  ];

  meta = with lib; {
    description = "Module for working with the Tableau Server REST API";
    homepage = "https://github.com/tableau/server-client-python";
    changelog = "https://github.com/tableau/server-client-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
