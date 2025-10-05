{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  fqdn,
  jsonschema,
  rfc3987,
  strict-rfc3339,
  fedora-messaging,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "weblate-schemas";
  version = "2025.5";

  pyproject = true;

  src = fetchPypi {
    pname = "weblate_schemas";
    inherit version;
    hash = "sha256-ZhFF3UD7lX/KXVDZFOn+Gc1w/cpzzVYVrbpVeJ9/wiE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fqdn
    jsonschema
    rfc3987
    strict-rfc3339
  ];

  nativeCheckInputs = [
    fedora-messaging
    pytestCheckHook
  ]
  ++ jsonschema.optional-dependencies.format;

  pythonImportsCheck = [ "weblate_schemas" ];

  meta = with lib; {
    description = "Schemas used by Weblate";
    homepage = "https://github.com/WeblateOrg/weblate_schemas";
    changelog = "https://github.com/WeblateOrg/weblate_schemas/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };

}
