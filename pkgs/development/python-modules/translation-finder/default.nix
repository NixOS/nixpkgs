{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  charset-normalizer,
  ruamel-yaml,
  weblate-language-data,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "translation-finder";
  version = "2.16";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a1C+j4Zo0DJ9BWDn5Zsu4zAftcUixfPktAWdqiFJpiU=";
  };

  patches = [ ./fix_tests.patch ];

  build-system = [ setuptools ];

  dependencies = [
    charset-normalizer
    ruamel-yaml
    weblate-language-data
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "translation_finder" ];

  meta = with lib; {
    description = "Translation file finder for Weblate";
    homepage = "https://github.com/WeblateOrg/translation-finder";
    changelog = "https://github.com/WeblateOrg/translation-finder/blob/${version}/CHANGES.rst";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ erictapen ];
  };

}
