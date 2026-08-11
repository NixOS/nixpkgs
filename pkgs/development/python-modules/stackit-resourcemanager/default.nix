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
  pname = "stackit-resourcemanager";
  version = "0.9.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "stackit_resourcemanager";
    inherit (finalAttrs) version;
    hash = "sha256-Mx6rmwvKmyJPeUFuO2Z4AR9O/oxTMDs+V4Jw+2AdkHs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    pydantic
    python-dateutil
    requests
    stackit-core
  ];

  pythonImportsCheck = [ "stackit.resourcemanager" ];

  # Module has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "STACKIT Resource Manager API client for Python";
    homepage = "https://github.com/stackitcloud/stackit-sdk-python";
    changelog = "https://github.com/stackitcloud/stackit-sdk-python/blob/services/resourcemanager/v${finalAttrs.version}/services/resourcemanager/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
