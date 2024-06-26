{
  lib,
  appdirs,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  flit-core,
  id,
  importlib-resources,
  platformdirs,
  pretend,
  pyasn1,
  pydantic,
  pyjwt,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
  requests,
  rfc8785,
  rich,
  securesystemslib,
  sigstore-protobuf-specs,
  sigstore-rekor-types,
  tuf,
}:

buildPythonPackage rec {
  pname = "sigstore-python";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "sigstore-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-AL1YXlgXRxA4tobPdSDfDGTYWhs/BS4bVrYBVQ9P6yM=";
  };

  build-system = [ flit-core ];

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
    rfc8785
    rich
    securesystemslib
    sigstore-protobuf-specs
    sigstore-rekor-types
    tuf
  ] ++ lib.optionals (pythonOlder "3.11") [ importlib-resources ];

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
    "test_sign_dsse"
    "test_sign_prehashed"
    "test_sign_rekor_entry_consistent"
    "test_store_reads_root_json"
    "test_store_reads_targets_json"
    "test_verification_materials_retrieves_rekor_entry"
    "test_verifier"
  ];

  meta = with lib; {
    description = "Codesigning tool for Python packages";
    homepage = "https://github.com/sigstore/sigstore-python";
    changelog = "https://github.com/sigstore/sigstore-python/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "sigstore";
  };
}
