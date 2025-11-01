{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  tomli,
  pytestCheckHook,
  gettext,
}:

buildPythonPackage rec {
  pname = "setuptools-gettext";
  version = "0.1.16";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "setuptools-gettext";
    tag = "v${version}";
    hash = "sha256-N59Hx6CyOzAin8KcMTAD++HFLDdJnJbql/U3fO2F3DU=";
  };

  build-system = [ setuptools ];

  dependencies = [ setuptools ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  pythonImportsCheck = [ "setuptools_gettext" ];

  nativeCheckInputs = [
    pytestCheckHook
    gettext
  ];

  meta = {
    changelog = "https://github.com/breezy-team/setuptools-gettext/releases/tag/v${version}";
    description = "Setuptools plugin for building mo files";
    homepage = "https://github.com/breezy-team/setuptools-gettext";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
