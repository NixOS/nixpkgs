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
}:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.11.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "aeb3f56a4c389495617f27bf218471b7969f636d25ddc491dfefeb8a1b3cd499";
  };

  propagatedBuildInputs = [ typing-extensions protobuf hidapi ecdsa mnemonic requests pyblake2 click construct libusb1 rlp shamir-mnemonic ];

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

  meta = with lib; {
    description = "Python library for communicating with TREZOR Bitcoin Hardware Wallet";
    homepage = "https://github.com/trezor/trezor-firmware/tree/master/python";
    license = licenses.gpl3;
    maintainers = with maintainers; [ np prusnak mmahut maintainers."1000101" ];
  };
}
