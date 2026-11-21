{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gettext,
  pytestCheckHook,
  setuptools,
  translate-toolkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "setuptools-gettext";
  version = "0.1.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "setuptools-gettext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0JFpoIUAZy89YVDAB1pb+x5tUO/Lo0DZzU5fNOLjm74=";
  };

  build-system = [ setuptools ];

  dependencies = [ setuptools ];

  optional-dependencies.translate-toolkit = [ translate-toolkit ];

  pythonImportsCheck = [ "setuptools_gettext" ];

  nativeCheckInputs = [
    pytestCheckHook
    gettext
  ];

  meta = {
    changelog = "https://github.com/breezy-team/setuptools-gettext/releases/tag/${finalAttrs.src.tag}";
    description = "Setuptools plugin for building mo files";
    homepage = "https://github.com/breezy-team/setuptools-gettext";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
