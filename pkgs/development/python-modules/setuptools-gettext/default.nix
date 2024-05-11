{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pythonAtLeast,
  setuptools,
  tomli,
  pytestCheckHook,
  gettext,
}:

buildPythonPackage rec {
  pname = "setuptools-gettext";
  version = "0.1.11";
  pyproject = true;

  # >=3.12 doesn't work because the package depends on `distutils`
  disabled = pythonOlder "3.7" || pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "setuptools-gettext";
    rev = "refs/tags/v${version}";
    hash = "sha256-yLKn4wwGgRdlsISAT71lD2vkIefsTJRB+OEA030adZY=";
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
    description = "setuptools plugin for building mo files";
    homepage = "https://github.com/breezy-team/setuptools-gettext";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
