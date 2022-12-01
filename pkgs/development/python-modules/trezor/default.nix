{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, isPy3k
, installShellFiles
, attrs
, click
, construct
, construct-classes
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
  version = "0.13.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "04a77b44005971819386bbd55242a1004b1f88fbbdb829deb039a1e0028a4af1";
  };

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    attrs
    click
    construct
    construct-classes
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
    "tests/test_firmware.py" # requires network downloads
  ];

  pythonImportsCheck = [ "trezorlib" ];

  postCheck = ''
    $out/bin/trezorctl --version
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
    maintainers = with maintainers; [ np prusnak mmahut ];
  };
}
