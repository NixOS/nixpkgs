{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "patatt";
  version = "0.4.9";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-qHhNxgP43vBSjrHp2Ygzq5J/f6YyBD4VDTp9S1ud6zo=";
  };

  propagatedBuildInputs = with python3Packages; [
    pynacl
  ];

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/utils/patatt/patatt.git/about/";
    license = licenses.mit0;
    description = "Add cryptographic attestation to patches sent via email";
    longDescription = ''
      This utility allows an easy way to add end-to-end cryptographic
      attestation to patches sent via mail.  It does so by adapting the
      DKIM email signature standard to include cryptographic
      signatures via the X-Developer-Signature email header.
    '';
    maintainers = with maintainers; [ yoctocell ];
  };
}
