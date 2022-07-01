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
, shamir-mnemonic
, simple-rlp
, typing-extensions
, trezor-udev-rules
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.13.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "cdb696fd01dad6a0cb23b61ea3a4867bb51cecda5cb2a77366fb6a53bff58ac4";
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
    shamir-mnemonic
    simple-rlp
    typing-extensions
  ] ++ lib.optionals stdenv.isLinux [
    trezor-udev-rules
  ];

  checkInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_stellar.py" # requires stellar-sdk
  ];

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
