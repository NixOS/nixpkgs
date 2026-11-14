{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  charset-normalizer,
  ruamel-yaml,
  weblate-language-data,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage (finalAttrs: {
  pname = "translation-finder";
  version = "3.4.0";

  pyproject = true;

  # nixpkgs-update: no auto update
  # Only weblate uses this and we want to follow its version constraints
  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "translation-finder";
    tag = finalAttrs.version;
    hash = "sha256-uPX3jKQoQxvtu01TwSmmFOjxMtiZsAwBja9jilaa5+o=";
  };

  build-system = [ setuptools ];

  dependencies = [
    charset-normalizer
    ruamel-yaml
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
