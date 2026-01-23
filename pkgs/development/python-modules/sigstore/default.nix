{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  appdirs,
  cryptography,
  id,
  importlib-resources,
  platformdirs,
  pyasn1,
  pydantic,
  pyjwt,
  pyopenssl,
  requests,
  rfc3161-client,
  rfc8785,
  rich,
  securesystemslib,
  sigstore-models,
  sigstore-protobuf-specs,
  sigstore-rekor-types,
  tuf,

  # tests
  pretend,
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "sigstore";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "sigstore-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wt9ZoMHTiMlbAab9p8/WF38/OiyCaqHPS5R7/fTAfxw=";
  };

  build-system = [ flit-core ];

  pythonRelaxDeps = [
    "sigstore-models"
  ];

  dependencies = [
    appdirs
    cryptography
    id
    importlib-resources
    platformdirs
    pyasn1
    pydantic
    pyjwt
    pyopenssl
    requests
    rfc3161-client
    rfc8785
    rich
    securesystemslib
    sigstore-models
    sigstore-protobuf-specs
    sigstore-rekor-types
    tuf
  ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "sigstore" ];

  disabledTests = [
    # Tests require network access
    "test_fail_init_url"
    "test_get_identity_token_bad_code"
    "test_identity_proof_claim_lookup"
    "test_init_url"
    "test_production"
    "test_sct_verify_keyring"
    "test_sign_rekor_entry_consistent"
    "test_verification_materials_retrieves_rekor_entry"
    "test_verifier"
    "test_fix_bundle_fixes_missing_checkpoint"
    "test_trust_root_bundled_get"
    "test_fix_bundle_upgrades_bundle"
    "test_trust_root_tuf_caches_and_requests"
    "test_regression_verify_legacy_bundle"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Codesigning tool for Python packages";
    homepage = "https://github.com/sigstore/sigstore-python";
    changelog = "https://github.com/sigstore/sigstore-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "sigstore";
  };
})
