{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-gettext,
}:

buildPythonPackage (finalAttrs: {
  pname = "weblate-language-data";
  version = "2026.11";
  pyproject = true;

  # nixpkgs-update: no auto update
  # Only weblate uses this and we want to follow its version constraints
  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "language-data";
    tag = finalAttrs.version;
    hash = "sha256-+ZCQbljkXp9NTtT+oYFuBpNxKfHXBzJUAhaqTot8430=";
  };

  build-system = [
    setuptools
    setuptools-gettext
  ]
  ++ setuptools-gettext.optional-dependencies.translate-toolkit;

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
