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
  securesystemslib,
  sigstore-protobuf-specs,
  sigstore-rekor-types,
  tuf,
}:

buildPythonPackage rec {
  pname = "sigstore-python";
  version = "2.1.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "sigstore-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-lqmrM4r1yPVCcvWNC9CKYMyryuIyliI2Y+TAYgAwA1Y=";
  };

  build-system = [ flit-core ];

  dependencies = [
    appdirs
    cryptography
    id
    importlib-resources
    pydantic
    pyjwt
    pyopenssl
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
  ];

  meta = with lib; {
    description = "Codesigning tool for Python packages";
    homepage = "https://github.com/sigstore/sigstore-python";
    changelog = "https://github.com/sigstore/sigstore-python/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "sigstore";
  };
}
