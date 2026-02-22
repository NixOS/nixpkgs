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

buildPythonPackage rec {
  pname = "translation-finder";
  version = "2.24";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "translation-finder";
    tag = version;
    hash = "sha256-OVAsw+snISVyz3ZvcfqCpv0BRfTNzYSpI+YLafW5OQg=";
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
    changelog = "https://github.com/WeblateOrg/translation-finder/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.gpl3Only;
    mainProgram = "weblate-discover";
    maintainers = with lib.maintainers; [ erictapen ];
  };

}
