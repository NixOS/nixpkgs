{ lib, fetchPypi, buildPythonPackage,
  protobuf, hidapi, ecdsa, mnemonic, requests, pyblake2, click, libusb1, rlp, isPy3k
}:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.11.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1132f6a97afb0979c5018b067494bc8917b881c02d965f991270a70543b5050c";
  };

  propagatedBuildInputs = [ protobuf hidapi ecdsa mnemonic requests pyblake2 click libusb1 rlp ];

  # There are no actual tests: "ImportError: No module named tests"
  doCheck = false;

  meta = {
    description = "Python library for communicating with TREZOR Hardware Wallet";
    homepage = https://github.com/trezor/python-trezor;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ np maintainers."1000101"];
  };
}
