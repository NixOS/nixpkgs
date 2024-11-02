{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xmltodict";
  version = "0.14.2";
  pyproject = true;

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
    license = licenses.mit;
    maintainers = [ ];
  };
}
