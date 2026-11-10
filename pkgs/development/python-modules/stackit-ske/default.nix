{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  nix-update-script,
  pydantic,
  python-dateutil,
  requests,
  stackit-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "stackit-ske";
  version = "1.14.0";
  pyproject = true;

  src = fetchPypi {
    pname = "stackit_ske";
    inherit (finalAttrs) version;
    hash = "sha256-3Vol2OoFPeV0hYd8NjMmwuHUlA1/uh6miavqD7AbJ44=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pydantic
    python-dateutil
    requests
    stackit-core
  ];

  pythonImportsCheck = [ "stackit.ske" ];

  # Module has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "STACKIT Cluster API client for Python";
    homepage = "https://github.com/stackitcloud/stackit-sdk-python";
    changelog = "https://github.com/stackitcloud/stackit-sdk-python/blob/services/ske/v${finalAttrs.version}/services/objectstorage/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
