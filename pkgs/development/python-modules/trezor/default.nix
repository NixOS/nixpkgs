{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
  # dependencies
  click,
  construct,
  construct-classes,
  cryptography,
  ecdsa,
  libusb1,
  mnemonic,
  noiseprotocol,
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
    requests
    shamir-mnemonic
    slip10
    typing-extensions
  ];

  optional-dependencies = {
    # bleak is missing on darwin
    # https://github.com/NixOS/nixpkgs/issues/456469
    ble = lib.optionals stdenv.hostPlatform.isLinux [ bleak ];
    extra = [ pillow ];
    hidapi = [ hidapi ];
    ethereum = [ web3 ];
    qt-widgets = [ pyqt5 ];
    # stellar = [ stellar-sdk ]; # missing in nixpkgs
    full = lib.flatten (lib.attrValues (lib.removeAttrs optional-dependencies [ "full" ]));
  };

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
