{
  lib,
  appdirs,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  flit-core,
  id,
  importlib-resources,
  nix-update-script,
  platformdirs,
  pretend,
  pyasn1,
  pydantic,
  pyjwt,
  pyopenssl,
  pytestCheckHook,
  requests,
  rfc3161-client,
  rfc8785,
  rich,
  securesystemslib,
  sigstore-models,
  sigstore-protobuf-specs,
  sigstore-rekor-types,
  tuf,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "sigstore-python";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "sigstore-python";
    tag = "v${version}";
    hash = "sha256-KAHGg2o5t8qfbvLGTzaVoV7AcMkgi3rXxyOQgSASl7A=";
  };

  pythonRelaxDeps = [
    "sigstore-rekor-types"
    "rfc3161-client"
    "cryptography"
  ];

  build-system = [ flit-core ];

  dependencies = [
    appdirs
    cryptography
    id
    importlib-resources
    pydantic
    pyjwt
    pyopenssl
    pyasn1
    rfc8785
    rfc3161-client
    platformdirs
    requests
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
    changelog = "https://github.com/sigstore/sigstore-python/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "sigstore";
  };
}
