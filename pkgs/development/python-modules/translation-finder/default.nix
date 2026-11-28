{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  charset-normalizer,
  weblate-language-data,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage (finalAttrs: {
  pname = "translation-finder";
  version = "3.10.0";

  pyproject = true;

  # nixpkgs-update: no auto update
  # Only weblate uses this and we want to follow its version constraints
  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "translation-finder";
    tag = finalAttrs.version;
    hash = "sha256-5KTR6+9ZpjDRtKnRuzFMOyX4ItInY7+Pg3Gnx3yyr5c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    charset-normalizer
    weblate-language-data
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "translation_finder" ];

  meta = {
    description = "Translation file finder for Weblate";
    homepage = "https://github.com/WeblateOrg/translation-finder";
    changelog = "https://github.com/WeblateOrg/translation-finder/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.gpl3Only;
    mainProgram = "weblate-discover";
    maintainers = with lib.maintainers; [ erictapen ];
  };

})
