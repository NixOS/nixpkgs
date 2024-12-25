{
  lib,
  appdirs,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  flit-core,
  id,
  importlib-resources,
  pretend,
  pydantic,
  pyjwt,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
  requests,
  rich,
  nix-update-script,
  securesystemslib,
  sigstore-protobuf-specs,
  sigstore-rekor-types,
  tuf,
  rfc8785,
  pyasn1,
  platformdirs,
}:

buildPythonPackage rec {
  pname = "sigstore-python";
  version = "3.5.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "sigstore-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-pAzS/LU5me3qoJo6EmuSFPDO/lqRDKIl5hjFiysWTdM=";
  };

  pythonRelaxDeps = [ "sigstore-rekor-types" ];

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
    platformdirs
    requests
    rich
    securesystemslib
    sigstore-protobuf-specs
    sigstore-rekor-types
    tuf
  ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

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
