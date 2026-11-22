{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchPypi,
  packaging,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
  typing-extensions,
  versioneer,
}:

buildPythonPackage rec {
  pname = "tableauserverclient";
  version = "0.41";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5JGXW58OGUZ/tkI7gUURqfVJwivOeMhoB5ol++gaDpU=";
  };

  pythonRelaxDeps = [
    "defusedxml"
    "urllib3"
  ];

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    defusedxml
    requests
    packaging
    typing-extensions
  ];

  nativeCheckInputs = [
    requests-mock
    pytestCheckHook
  ];

  # Tests attempt to create some file artifacts and fails
  doCheck = false;

  pythonImportsCheck = [ "tableauserverclient" ];

  meta = {
    description = "Module for working with the Tableau Server REST API";
    homepage = "https://github.com/tableau/server-client-python";
    changelog = "https://github.com/tableau/server-client-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
