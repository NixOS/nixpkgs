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
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "secure-systems-lab";
    repo = "securesystemslib";
    tag = "v${version}";
    hash = "sha256-ERFRLNHD3OhbMEGBEnDLkRYGv4f+bYg9MStS5IarcPA=";
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
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  pythonImportsCheck = [ "securesystemslib" ];

  disabledTestPaths = [
    # pykcs11 is not available
    "tests/test_hsm_signer.py"
    # Ignore vendorized tests
    "securesystemslib/_vendor/"
  ];

<<<<<<< HEAD
  meta = {
    description = "Cryptographic and general-purpose routines";
    homepage = "https://github.com/secure-systems-lab/securesystemslib";
    changelog = "https://github.com/secure-systems-lab/securesystemslib/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Cryptographic and general-purpose routines";
    homepage = "https://github.com/secure-systems-lab/securesystemslib";
    changelog = "https://github.com/secure-systems-lab/securesystemslib/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
