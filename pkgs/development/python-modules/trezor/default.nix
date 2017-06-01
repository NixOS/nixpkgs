{ lib, fetchPypi, buildPythonPackage, protobuf3_0, hidapi, ecdsa, mnemonic }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "trezor";
  version = "0.7.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d05f388bb56b6f61cc727999cc725078575238a0b6172450322bc55c437fefe5";
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
