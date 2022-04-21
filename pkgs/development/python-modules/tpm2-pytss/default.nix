{ lib, buildPythonPackage, fetchPypi, pythonOlder
, pkgconfig, asn1crypto, swig
, tpm2-tss
, cryptography, ibm-sw-tpm2
}:

buildPythonPackage rec {
  pname = "tpm2-pytss";
  version = "1.1.0";
  disabled = pythonOlder "3.5";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-O0d1b99/V8b3embg8veerTrJGSVb/prlPVb7qSHErdQ=";
  };

  buildInputs = [ pkgconfig asn1crypto ];
  nativeBuildInputs = [ swig ];
  # The TCTI is dynamically loaded from tpm2-tss, we have to provide the library to the end-user
  propagatedBuildInputs = [ tpm2-tss ];

  checkInputs = [
    cryptography
    # provide tpm_server used as simulator for the tests
    ibm-sw-tpm2
  ];

  meta = with lib; {
    homepage = "https://github.com/tpm2-software/tpm2-pytss";
    description = "TPM2 TSS Python bindings for Enhanced System API (ESYS)";
    license = licenses.bsd2;
    maintainers = with maintainers; [ baloo ];
  };
}
