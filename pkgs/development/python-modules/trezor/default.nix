{ lib, fetchPypi, buildPythonPackage, protobuf3_2, hidapi, ecdsa, mnemonic
, requests
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "trezor";
  version = "0.7.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6bdb69fc125ba705854e21163be6c7da3aa17c2a3a84f40b6d8a3f6e4a8cb314";
  };

  propagatedBuildInputs = [ protobuf3_2 hidapi requests ];

  buildInputs = [ ecdsa mnemonic ];

  # There are no actual tests: "ImportError: No module named tests"
  doCheck = false;

  meta = {
    description = "Python library for communicating with TREZOR Bitcoin Hardware Wallet";
    homepage = https://github.com/trezor/python-trezor;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ np ];
  };
}
