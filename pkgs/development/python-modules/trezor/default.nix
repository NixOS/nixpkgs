{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  construct,
  construct-classes,
  ecdsa,
  libusb1,
  mnemonic,
  requests,
  setuptools,
  typing-extensions,
  trezor-udev-rules,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "trezor";
  version = "0.13.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lFC9e7nSPl4zo8nljhjwWLRMnZw0ymZLSYGnlaqfse8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    construct
    construct-classes
    ecdsa
    libusb1
    mnemonic
    requests
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
