{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xmltodict";
  version = "0.14.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IB58KLshDjdJmdHd5jgpI6sO0ail+u7OSKtSW3gQpVM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xmltodict" ];

  meta = with lib; {
    description = "Makes working with XML feel like you are working with JSON";
    homepage = "https://github.com/martinblech/xmltodict";
    changelog = "https://github.com/martinblech/xmltodict/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
