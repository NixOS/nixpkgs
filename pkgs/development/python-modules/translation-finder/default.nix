{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  charset-normalizer,
  ruamel-yaml,
  weblate-language-data,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "translation-finder";
  version = "3.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "translation-finder";
    tag = finalAttrs.version;
    hash = "sha256-sRqn7K39R4A83USCng5wu14eKq4VqUp9tPzg8Qb8MOU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    charset-normalizer
    ruamel-yaml
    weblate-language-data
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
