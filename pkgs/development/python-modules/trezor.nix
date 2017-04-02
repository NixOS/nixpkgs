{ lib, fetchurl, buildPythonPackage, protobuf3_0, hidapi, ecdsa, mnemonic }:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.7.12";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/t/${pname}/${name}.tar.gz";
    sha256 = "0ryqdk13x60qq5s68i9dfc1na4dka66kdxqycxignzg9k9ykaa8g";
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
