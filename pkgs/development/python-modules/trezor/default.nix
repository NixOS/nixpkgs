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
}:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.11.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6f4b47b37a21247535fc43411cb70a8c61ef0a5a2dfee668bd05611e2741fb8";
  };

  propagatedBuildInputs = [ typing-extensions protobuf hidapi ecdsa mnemonic requests pyblake2 click construct libusb1 rlp ];

  # build requires UTF-8 locale
  LANG = "en_US.UTF-8";

  checkInputs = [
    pytest
  ];

  # disable test_tx_api.py as it requires being online
  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m pytest --pyarg trezorlib.tests.unit_tests --ignore trezorlib/tests/unit_tests/test_tx_api.py
    runHook postCheck
  '';

  meta = {
    description = "Python library for communicating with TREZOR Bitcoin Hardware Wallet";
    homepage = https://github.com/trezor/python-trezor;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ np prusnak ];
  };
}
