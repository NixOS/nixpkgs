{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  translate-toolkit,
}:

buildPythonPackage (finalAttrs: {
  pname = "weblate-language-data";
  version = "2026.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "language-data";
    tag = finalAttrs.version;
    hash = "sha256-v64YlcgHT94SCTGebR//Cnjj+NeH3TJZsXB8EztJk9s=";
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
