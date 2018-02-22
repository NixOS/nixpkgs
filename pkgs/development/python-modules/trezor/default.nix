{ lib, fetchPypi, buildPythonPackage,
  protobuf, hidapi, ecdsa, mnemonic, requests, pyblake2, click, libusb1
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "trezor";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2dd01e11d669cb8f5e40fcf1748bcabc41fb5f41edb010fc807dc3088f9bd7de";
  };

  propagatedBuildInputs = [ protobuf hidapi ecdsa mnemonic requests pyblake2 click libusb1 ];

  # There are no actual tests: "ImportError: No module named tests"
  doCheck = false;

  meta = {
    description = "Python library for communicating with TREZOR Bitcoin Hardware Wallet";
    homepage = https://github.com/trezor/python-trezor;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ np ];
  };
}
