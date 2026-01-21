{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # optional-dependencies
  # PySPX
  pyspx,
  # awskms
  boto3,
  botocore,
  cryptography,
  # azurekms
  azure-identity,
  azure-keyvault-keys,
  # hsm
  asn1crypto,
  # gcpkms
  google-cloud-kms,
  # pynacl
  pynacl,

  # tests
  ed25519,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "securesystemslib";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "secure-systems-lab";
    repo = "securesystemslib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ERFRLNHD3OhbMEGBEnDLkRYGv4f+bYg9MStS5IarcPA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"hatchling==1.27.0"' '"hatchling"'
  '';

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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "securesystemslib" ];

  disabledTestPaths = [
    # pykcs11 is not available
    "tests/test_hsm_signer.py"
    # Ignore vendorized tests
    "securesystemslib/_vendor/"
  ];

  meta = {
    description = "Cryptographic and general-purpose routines";
    homepage = "https://github.com/secure-systems-lab/securesystemslib";
    changelog = "https://github.com/secure-systems-lab/securesystemslib/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
