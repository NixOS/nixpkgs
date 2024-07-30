{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchPypi,
  packaging,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "tableauserverclient";
  version = "0.31";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e00/+yVKg7dGGq3Os+oWu/F93j5e9dnwWZxKwm+soqM=";
  };

  postPatch = ''
    # Remove vendorized versioneer
    rm versioneer.py
  '';

  pythonRelaxDeps = [ "urllib3" ];

  nativeBuildInputs = [
    setuptools
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

  pythonImportsCheck = [ "tableauserverclient" ];

  meta = with lib; {
    description = "Module for working with the Tableau Server REST API";
    homepage = "https://github.com/tableau/server-client-python";
    changelog = "https://github.com/tableau/server-client-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
