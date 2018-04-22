{ lib, fetchPypi, buildPythonPackage,
  protobuf, hidapi, ecdsa, mnemonic, requests, pyblake2, click, libusb1, rlp
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "trezor";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a481191011bade98f1e9f1201e7c72a83945050657bbc90dc4ac32dc8b8b46a4";
  };

  propagatedBuildInputs = [ protobuf hidapi ecdsa mnemonic requests pyblake2 click libusb1 rlp ];

  # There are no actual tests: "ImportError: No module named tests"
  doCheck = false;

  meta = {
    description = "Python library for communicating with TREZOR Bitcoin Hardware Wallet";
    homepage = https://github.com/trezor/python-trezor;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ np ];
  };
}
