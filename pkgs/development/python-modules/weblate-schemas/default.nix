{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fqdn,
  jsonschema,
  rfc3987,
  strict-rfc3339,
  fedora-messaging,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "weblate-schemas";
  version = "2026.4";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "WeblateOrg";
    repo = "weblate_schemas";
    tag = finalAttrs.version;
    hash = "sha256-OPuhRsUmVte54UPNna76N5Kbg1Tl7p8OdKbE6VHWcvg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonschema
  ];

  nativeCheckInputs = [
    pytestCheckHook
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
