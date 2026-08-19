{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  hatchling,
  nix-update-script,
  poetry-core,
  pydantic,
  pyjwt,
  requests,
  setuptools,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "stackit-core";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "stackit_core";
    inherit (finalAttrs) version;
    hash = "sha256-uK+Rh3zbBg1paaMD2M8gvAszs0Wv2R9nnESphzgeLUc=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    cryptography
    pydantic
    pyjwt
    requests
    urllib3
  ];

  pythonImportsCheck = [ "stackit.core" ];

  # Tests are not included in PyPI release
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Core functionality for the STACKIT SDK";
    homepage = "https://github.com/stackitcloud/stackit-sdk-python";
    changelog = "https://github.com/stackitcloud/stackit-sdk-python/releases/tag/core/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
