{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  uv-build,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "scim2-models";
  version = "0.5.0";

  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit version;
    pname = "scim2_models";
    hash = "sha256-9K7iBKN304vG4nEOAW33JWRrEo3ZoK7lCGl5fUTcGww=";
  };

  build-system = [ uv-build ];

  dependencies = [ pydantic ] ++ pydantic.optional-dependencies.email;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "scim2_models" ];

  meta = {
    description = "SCIM2 models serialization and validation with pydantic";
    homepage = "https://github.com/python-scim/scim2-models";
    changelog = "https://github.com/python-scim/scim2-models/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
