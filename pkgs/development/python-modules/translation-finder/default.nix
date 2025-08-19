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
  version = "2.23";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "translation-finder";
    tag = version;
    hash = "sha256-SmCADimYcSsD3iUt/QqF2SwJPzbFLw5v7SWVSeOyelQ=";
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
    changelog = "https://github.com/WeblateOrg/translation-finder/blob/${src.tag}/CHANGES.rst";
    license = licenses.gpl3Only;
    mainProgram = "weblate-discover";
    maintainers = with maintainers; [ erictapen ];
  };

}
