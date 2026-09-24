{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  uuid6,
  pytestCheckHook,
  requests,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "typeid-python";
  version = "0.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "akhundMurad";
    repo = "typeid-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L1t2jcUWW/vCfSPHvxZgBBguNvrtWexCRAphoQBnAFM=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    uuid6
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
    pyyaml
  ];

  disabledTestPaths = [
    # Requires network access to download spec fixtures
    "tests/test_spec.py"
  ];

  pythonImportsCheck = [ "typeid" ];

  meta = {
    changelog = "https://github.com/akhundMurad/typeid-python/releases/tag/v${finalAttrs.version}";
    description = "Type-safe, K-sortable, and globally unique identifiers inspired by Stripe IDs";
    homepage = "https://github.com/akhundMurad/typeid-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
