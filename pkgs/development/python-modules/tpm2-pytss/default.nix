{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, asn1crypto
, cffi
, cryptography
, pkgconfig # see nativeBuildInputs
, pkg-config # see nativeBuildInputs
, pycparser
, pytestCheckHook
, python
, pyyaml
, setuptools-scm
, tpm2-tss
, tpm2-tools
, swtpm
}:

buildPythonPackage rec {
  pname = "tpm2-pytss";
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uPFUc0IvN39ZxyF9zRR5FlzOYt+jOTTsl2oni68unv4=";
  };

  patches = [
    # Fix hardcoded `fapi-config.json` configuration path
    ./fapi-config.patch
  ];

  postPatch = ''
    sed -i "s#@TPM2_TSS@#${tpm2-tss.out}#" src/tpm2_pytss/FAPI.py
  '';

  # Hardening has to be disabled
  # due to pycparsing handling it poorly.
  # See https://github.com/NixOS/nixpkgs/issues/252023
  # for more details.
  hardeningDisable = [
    "fortify"
  ];

  nativeBuildInputs = [
    cffi
    pkgconfig # this is the Python module
    pkg-config # this is the actual pkg-config tool
    setuptools-scm
  ];

  buildInputs = [
    tpm2-tss
  ];

  propagatedBuildInputs = [
    cffi
    asn1crypto
    cryptography
    pyyaml
  ];

  doCheck = true;

  nativeCheckInputs = [
    pytestCheckHook
    tpm2-tools
    swtpm
  ];

  pythonImportsCheck = [
    "tpm2_pytss"
  ];

  meta = with lib; {
    homepage = "https://github.com/tpm2-software/tpm2-pytss";
    changelog = "https://github.com/tpm2-software/tpm2-pytss/blob/${version}/CHANGELOG.md";
    description = "TPM2 TSS Python bindings for Enhanced System API (ESYS)";
    license = licenses.bsd2;
    maintainers = with maintainers; [ baloo ];
  };
}
