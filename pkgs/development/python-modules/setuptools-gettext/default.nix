{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gettext,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "setuptools-gettext";
  version = "0.1.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "setuptools-gettext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IhlJ+g4ppHzG6n0OawvZULm9DqyDm2mjiXmc2ft+xXU=";
  };

  build-system = [ setuptools ];

  dependencies = [ setuptools ];

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
