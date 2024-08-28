{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "suds";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HVz6dBFxk7JEpCM/JGxIPZ9BGYtEjF8UqLrRHE9knys=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "suds" ];

  meta = {
    changelog = "https://github.com/suds-community/suds/blob/v${version}/CHANGELOG.md";
    description = "Lightweight SOAP python client for consuming Web Services";
    homepage = "https://github.com/suds-community/suds";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ wrmilling ];
  };
}
