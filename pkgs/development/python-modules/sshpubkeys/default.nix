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
}
