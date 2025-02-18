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
  version = "2.19";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "translation-finder";
    tag = version;
    hash = "sha256-Hc1KxmzlFqCLHSAgFF8cgxH0dTdUnBV/2T2ZkfzVvSw=";
  };

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
