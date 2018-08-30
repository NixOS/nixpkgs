{ lib, fetchPypi, buildPythonPackage,
  protobuf, hidapi, ecdsa, mnemonic, requests, pyblake2, click, libusb1, rlp, isPy3k
}:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.10.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4dba4d5c53d3ca22884d79fb4aa68905fb8353a5da5f96c734645d8cf537138d";
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
