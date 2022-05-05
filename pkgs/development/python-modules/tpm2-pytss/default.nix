{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, asn1crypto
, cffi
, cryptography
, ibm-sw-tpm2
, pkg-config
, pkgconfig
, pycparser
, pytestCheckHook
, python
, setuptools-scm
, tpm2-tss
}:

buildPythonPackage rec {
  pname = "tpm2-pytss";
  version = "1.1.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-O0d1b99/V8b3embg8veerTrJGSVb/prlPVb7qSHErdQ=";
  };

  nativeBuildInputs = [
    cffi
    pkgconfig
    # somehow propagating from pkgconfig does not work
    pkg-config
    setuptools-scm
  ];

  buildInputs = [
    tpm2-tss
  ];

  propagatedBuildInputs = [
    cffi
    asn1crypto
    cryptography
  ];

  # https://github.com/tpm2-software/tpm2-pytss/issues/341
  doCheck = false;

  checkInputs = [
    ibm-sw-tpm2
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tpm2_pytss" ];

  meta = with lib; {
    homepage = "https://github.com/tpm2-software/tpm2-pytss";
    description = "TPM2 TSS Python bindings for Enhanced System API (ESYS)";
    license = licenses.bsd2;
    maintainers = with maintainers; [ baloo ];
  };
}
