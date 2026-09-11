{
  lib,
  buildPythonPackage,
  fastjsonschema,
  fetchFromGitHub,
  hatchling,
  nix-update-script,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "validate-pyproject-schema-store";
  version = "2026.09.04";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "henryiii";
    repo = "validate-pyproject-schema-store";
    tag = finalAttrs.version;
    hash = "sha256-GgCqp3AdBomt67scee6kBWN5oMX27v5lSwNB8297HDE=";
  };

  build-system = [ hatchling ];

  dependencies = [ fastjsonschema ];

  # Circular dependency with validate-pyproject
  doCheck = false;

  pythonImportsCheck = [ "validate_pyproject_schema_store" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Daily automatic mirror of SchemaStore for validate-pyproject";
    homepage = "https://github.com/henryiii/validate-pyproject-schema-store";
    changelog = "https://github.com/henryiii/validate-pyproject-schema-store/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
