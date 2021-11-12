{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, isPy3k
, installShellFiles
, attrs
, click
, construct
, ecdsa
, hidapi
, libusb1
, mnemonic
, pillow
, protobuf
, pyblake2
, requests
, rlp
, shamir-mnemonic
, typing-extensions
, trezor-udev-rules
, pytest
}:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.12.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e180d9f9f8b69176b5ef36311b6161f5b793b538eb2dfd4babbb4d3fb1e374e";
  };

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    attrs
    click
    construct
    ecdsa
    hidapi
    libusb1
    mnemonic
    pillow
    protobuf
    pyblake2
    requests
    rlp
    shamir-mnemonic
    typing-extensions
  ] ++ lib.optionals stdenv.isLinux [
    trezor-udev-rules
  ];

  checkInputs = [
    pytest
  ];

  # disable test_tx_api.py as it requires being online
  checkPhase = ''
    runHook preCheck
    pytest --pyargs tests --ignore tests/test_tx_api.py
    runHook postCheck
  '';

  postFixup = ''
    mkdir completions
    _TREZORCTL_COMPLETE=source_bash $out/bin/trezorctl > completions/trezorctl || true
    _TREZORCTL_COMPLETE=source_zsh $out/bin/trezorctl > completions/_trezorctl || true
    _TREZORCTL_COMPLETE=source_fish $out/bin/trezorctl > completions/trezorctl.fish || true
    installShellCompletion --bash completions/trezorctl
    installShellCompletion --zsh completions/_trezorctl
    installShellCompletion --fish completions/trezorctl.fish
  '';

  meta = with lib; {
    description = "Python library for communicating with Trezor Hardware Wallet";
    homepage = "https://github.com/trezor/trezor-firmware/tree/master/python";
    license = licenses.gpl3;
    maintainers = with maintainers; [ np prusnak mmahut _1000101 ];
  };
}
