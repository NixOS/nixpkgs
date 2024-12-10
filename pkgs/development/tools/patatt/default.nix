{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "patatt";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-mAgm9lKdJXbCZ8ofVk1b7wRstH5UIVu1mO1sS5stCig=";
  };

  propagatedBuildInputs = with python3Packages; [
    pynacl
  ];

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/utils/patatt/patatt.git/about/";
    license = licenses.mit0;
    description = "Add cryptographic attestation to patches sent via email";
    mainProgram = "patatt";
    longDescription = ''
      This utility allows an easy way to add end-to-end cryptographic
      attestation to patches sent via mail.  It does so by adapting the
      DKIM email signature standard to include cryptographic
      signatures via the X-Developer-Signature email header.
    '';
    maintainers = with maintainers; [
      qyliss
      yoctocell
    ];
  };
}
