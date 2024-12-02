{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "suds";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suds-community";
    repo = "suds";
    rev = "refs/tags/v${version}";
    hash = "sha256-YdL+zDelRspQ6VMqa45vK1DDS3HjFvKE1P02USVBrEo=";
  };

  build-system = [ setuptools ];

  env.SUDS_PACKAGE = "suds";

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
