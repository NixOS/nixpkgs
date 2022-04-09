{ lib, buildPythonPackage, fetchPypi, pythonOlder
, pkg-config, swig
, tpm2-tss
, cryptography, ibm-sw-tpm2
}:

buildPythonPackage rec {
  pname = "tpm2-pytss";

  # Last version on github is 0.2.4, but it looks
  # like a mistake (it's missing commits from 0.1.9)
  version = "1.0.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Gx1nIXYuhTmQva9LmtTYvd1nyRH/pBQZ5bJ8OLcc1lo=";
  };
  postPatch = ''
    substituteInPlace tpm2_pytss/config.py --replace \
      'SYSCONFDIR = CONFIG.get("sysconfdir", "/etc")' \
      'SYSCONFDIR = "${tpm2-tss}/etc"'
  '';

  nativeBuildInputs = [ pkg-config swig ];
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
