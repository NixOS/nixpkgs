{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jsonschema,
  fedora-messaging,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage (finalAttrs: {
  pname = "weblate-schemas";
  version = "2026.7";

  pyproject = true;

  # nixpkgs-update: no auto update
  # Only weblate uses this and we want to follow its version constraints
  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "weblate_schemas";
    tag = finalAttrs.version;
    hash = "sha256-UDazCDxGMG9CaWQ5vC/wFRyhkG398InOoXv0M3Bd4Mw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    fedora-messaging
  ]
  ++ jsonschema.optional-dependencies.format;

  pythonImportsCheck = [ "weblate_schemas" ];

  meta = {
    description = "Schemas used by Weblate";
    homepage = "https://github.com/WeblateOrg/weblate_schemas";
    changelog = "https://github.com/WeblateOrg/weblate_schemas/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };

})
