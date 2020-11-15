{ lib, fetchPypi, buildPythonPackage, isPy3k, python, pytest
, typing-extensions
, protobuf
, hidapi
, ecdsa
, mnemonic
, requests
, pyblake2
, click
, construct
, libusb1
, rlp
, shamir-mnemonic
, trezor-udev-rules
}:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.12.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ycmpwjv5xp25993divjhaq5j766zgcy22xx39xfc1pcvldq5g7n";
  };

  propagatedBuildInputs = [ typing-extensions protobuf hidapi ecdsa mnemonic requests pyblake2 click construct libusb1 rlp shamir-mnemonic trezor-udev-rules ];

  checkInputs = [
    pytest
  ];

  # disable test_tx_api.py as it requires being online
  checkPhase = ''
    runHook preCheck
    pytest --pyargs tests --ignore tests/test_tx_api.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Python library for communicating with TREZOR Bitcoin Hardware Wallet";
    homepage = "https://github.com/trezor/trezor-firmware/tree/master/python";
    license = licenses.gpl3;
    maintainers = with maintainers; [ np prusnak mmahut maintainers."1000101" ];
  };
}
