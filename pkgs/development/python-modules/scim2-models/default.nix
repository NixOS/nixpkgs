{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "scim2-models";
  version = "0.5.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-scim";
    repo = "scim2-models";
    tag = version;
    hash = "sha256-ahwHmWsM9IoK+yq0Qd0c2+kagMlXGi80/rAB4UQsf6U=";
  };

  build-system = [ hatchling ];

  dependencies = [ pydantic ] ++ pydantic.optional-dependencies.email;

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    substituteInPlace doc/tutorial.rst \
      --replace-fail "TzInfo(UTC)" "TzInfo(0)"
  '';

  pythonImportsCheck = [ "scim2_models" ];

  meta = {
    description = "SCIM2 models serialization and validation with pydantic";
    homepage = "https://github.com/python-scim/scim2-models";
    changelog = "https://github.com/python-scim/scim2-models/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
  };
})
