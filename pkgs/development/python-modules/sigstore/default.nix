{ lib
, appdirs
, buildPythonPackage
, cryptography
, fetchFromGitHub
, flit-core
, id
, importlib-resources
, pretend
, pydantic
, pyjwt
, pyopenssl
, pytestCheckHook
, requests
, rich
, securesystemslib
, sigstore-protobuf-specs
, sigstore-rekor-types
, tuf
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sigstore-python";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "sigstore-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-WH6Pme8ZbfW5xqBT056eVJ3HZP1D/lAULtyN6k0uMaA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "sigstore"
  ];

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
    description = "A codesigning tool for Python packages";
    homepage = "https://github.com/sigstore/sigstore-python";
    changelog = "https://github.com/sigstore/sigstore-python/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
