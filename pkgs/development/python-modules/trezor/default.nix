{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  installShellFiles,
  attrs,
  click,
  construct,
  construct-classes,
  ecdsa,
  hidapi,
  libusb1,
  mnemonic,
  pillow,
  protobuf,
  requests,
  shamir-mnemonic,
  simple-rlp,
  typing-extensions,
  trezor-udev-rules,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.13.8";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y01O3fNWAyV8MhYY2FSMajWyc4Rle2XjsL261jWlfP8=";
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
    requests
    shamir-mnemonic
    simple-rlp
    typing-extensions
  ] ++ lib.optionals stdenv.isLinux [ trezor-udev-rules ];

  nativeCheckInputs = [ pytestCheckHook ];

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
    mainProgram = "trezorctl";
    homepage = "https://github.com/trezor/trezor-firmware/tree/master/python";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      np
      prusnak
      mmahut
    ];
  };
}
