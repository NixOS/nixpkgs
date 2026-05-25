{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  translate-toolkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "weblate-language-data";
  version = "2026.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "language-data";
    tag = finalAttrs.version;
    hash = "sha256-7wNm6bu2L1/eF5D49wSYu1qfVC5Fl5MbaSbXO/az4F4=";
  };

  build-system = [ setuptools ];

  dependencies = [ translate-toolkit ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "weblate_language_data" ];

  meta = {
    description = "Language definitions used by Weblate";
    homepage = "https://github.com/WeblateOrg/language-data";
    changelog = "https://github.com/WeblateOrg/language-data/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
