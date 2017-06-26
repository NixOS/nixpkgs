{ lib, fetchPypi, buildPythonPackage, protobuf3_0, hidapi, ecdsa, mnemonic }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "trezor";
  version = "0.7.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7e4f509263ca172532b4c0a440d164add7cdc021b4370a253d51eba5806b618";
  };

  propagatedBuildInputs = [ protobuf3_0 hidapi ];

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
