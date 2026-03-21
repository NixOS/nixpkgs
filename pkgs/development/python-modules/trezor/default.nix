{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
  pytest-random-order,
  # dependencies
  click,
  construct,
  construct-classes,
  cryptography,
  keyring,
  libusb1,
  mnemonic,
  noiseprotocol,
  platformdirs,
  requests,
  shamir-mnemonic,
  slip10,
  typing-extensions,
  # optional-dependencies
  bleak,
  pillow,
  hidapi,
  web3,
  pyqt5,
}:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.20.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TAmOIDFbJxZnOr3vQCgi5xiRAVmMfAPyN0ndIBDuJQQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    construct
    construct-classes
    cryptography
    keyring
    libusb1
    mnemonic
    noiseprotocol
    platformdirs
    requests
    shamir-mnemonic
    slip10
    typing-extensions
  ];

  optional-dependencies = {
    ble = [ bleak ];
    extra = [ pillow ];
    hidapi = [ hidapi ];
    ethereum = [ web3 ];
    qt-widgets = [ pyqt5 ];
    # stellar = [ stellar-sdk ]; # missing in nixpkgs
    full = lib.flatten (lib.attrValues (lib.removeAttrs optional-dependencies [ "full" ]));
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-random-order
  ];

  disabledTestPaths = [
    "tests/test_stellar.py" # requires stellar-sdk
    "tests/test_firmware.py" # requires network downloads
  ];

  pythonImportsCheck = [ "trezorlib" ];

  postCheck = ''
    $out/bin/trezorctl --version
  '';

  meta = {
    description = "Python library for communicating with Trezor Hardware Wallet";
    mainProgram = "trezorctl";
    homepage = "https://github.com/trezor/trezor-firmware/tree/master/python";
    changelog = "https://github.com/trezor/trezor-firmware/blob/python/v${version}/python/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      np
      prusnak
      mmahut
    ];
  };
}
