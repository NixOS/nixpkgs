{ lib
, fetchPypi
, buildPythonPackage
, cryptography
, ecdsa
}:

buildPythonPackage rec {
  pname = "sshpubkeys";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b388399caeeccdc145f06fd0d2665eeecc545385c60b55c282a15a022215af80";
  };

  buildInputs = [ cryptography ecdsa ];

  # For some reason nix can't find the "tests" module.
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/ojarva/python-sshpubkeys;
    description = "OpenSSH public key parser for Python";
    license = licenses.bsd3;
    longDescription = ''
      Native implementation for validating OpenSSH public keys.  Currently
      ssh-rsa, ssh-dss (DSA), ssh-ed25519 and ecdsa keys with NIST curves are
      supported.
    '';
    maintainers = [ maintainers.bsima ];
  };
}
