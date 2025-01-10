{
  lib,
  buildPythonPackage,
  fetchPypi,
  charset-normalizer,
  ruamel-yaml,
  weblate-language-data,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "translation-finder";
  version = "2.16";

  src = fetchPypi {
    pname = "translation-finder";
    inherit version;
    hash = "sha256-a1C+j4Zo0DJ9BWDn5Zsu4zAftcUixfPktAWdqiFJpiU=";
  };

  patches = [ ./fix_tests.patch ];

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
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ erictapen ];
  };

}
