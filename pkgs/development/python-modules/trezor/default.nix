{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  click,
  construct,
  construct-classes,
  cryptography,
  ecdsa,
  libusb1,
  mnemonic,
  noiseprotocol,
  pillow,
  requests,
  shamir-mnemonic,
  slip10,
  typing-extensions,
  bleak,
  trezor-udev-rules,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.20.0.dev0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hU2J5TORWU55zoxjfsFPjk4VtNoxmVsjceDVvTKXKxI=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    construct
    construct-classes
    cryptography
    ecdsa
    libusb1
    mnemonic
    noiseprotocol
    pillow
    requests
    shamir-mnemonic
    slip10
    typing-extensions
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    bleak
    trezor-udev-rules
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_stellar.py" # requires stellar-sdk
    "tests/test_firmware.py" # requires network downloads
  ];

  pythonImportsCheck = [ "trezorlib" ];

  postCheck = ''
    $out/bin/trezorctl --version
  '';

  meta = with lib; {
    description = "Python library for communicating with Trezor Hardware Wallet";
    mainProgram = "trezorctl";
    homepage = "https://github.com/trezor/trezor-firmware/tree/master/python";
    changelog = "https://github.com/trezor/trezor-firmware/blob/python/v${version}/python/CHANGELOG.md";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      np
      prusnak
      mmahut
    ];
  };
}
