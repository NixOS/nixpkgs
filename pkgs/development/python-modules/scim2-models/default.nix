{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  hatchling,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "scim2-models";
  version = "0.3.3";

  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "scim2_models";
    hash = "sha256-od+1KaAwmZ1slsACYRYRpy92xz5s8hcopz0LiwVJhfA=";
  };

  build-system = [ hatchling ];

  dependencies = [ pydantic ] ++ pydantic.optional-dependencies.email;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "scim2_models" ];

  meta = with lib; {
    description = "SCIM2 models serialization and validation with pydantic";
    homepage = "https://github.com/python-scim/scim2-models";
    changelog = "https://github.com/python-scim/scim2-models/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ erictapen ];
  };
}
