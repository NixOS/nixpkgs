{
  lib,
  asn1crypto,
  azure-identity,
  azure-keyvault-keys,
  boto3,
  botocore,
  buildPythonPackage,
  cryptography,
  ed25519,
  fetchFromGitHub,
  google-cloud-kms,
  hatchling,
  pynacl,
  pyspx,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "securesystemslib";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "secure-systems-lab";
    repo = "securesystemslib";
    rev = "refs/tags/v${version}";
    hash = "sha256-HAYsmsW5GKLmfq9FVVsME+tE7Qg0jx9YIWw1UQWwV2c=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    PySPX = [ pyspx ];
    awskms = [
      boto3
      botocore
      cryptography
    ];
    azurekms = [
      azure-identity
      azure-keyvault-keys
      cryptography
    ];
    crypto = [ cryptography ];
    gcpkms = [
      cryptography
      google-cloud-kms
    ];
    hsm = [
      asn1crypto
      cryptography
      #   pykcs11
    ];
    pynacl = [ pynacl ];
    # Circular dependency
    # sigstore = [
    #   sigstore
    # ];
  };

  nativeCheckInputs = [
    ed25519
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "securesystemslib" ];

  disabledTestPaths = [
    # pykcs11 is not available
    "tests/test_hsm_signer.py"
    # Ignore vendorized tests
    "securesystemslib/_vendor/"
  ];

  meta = with lib; {
    description = "Cryptographic and general-purpose routines";
    homepage = "https://github.com/secure-systems-lab/securesystemslib";
    changelog = "https://github.com/secure-systems-lab/securesystemslib/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
