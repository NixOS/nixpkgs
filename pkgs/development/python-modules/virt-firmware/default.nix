{
  lib,
  pkgs,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  cryptography,
  pytestCheckHook,
  pefile,
}:

buildPythonPackage rec {
  pname = "virt-firmware";
  version = "24.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rqhaKDOQEOj6bcRz3qZJ+a4yG1qTC9SUjuxMhZlnmwU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    setuptools
    cryptography
    pefile
  ];

  # tests require systemd-detect-virt
  doCheck = lib.meta.availableOn stdenv.hostPlatform pkgs.systemd;

  nativeCheckInputs = [
    pytestCheckHook
    pkgs.systemd
  ];

  pytestFlagsArray = [ "tests/tests.py" ];

  pythonImportsCheck = [ "virt.firmware.efi" ];

  meta = with lib; {
    description = "Tools for virtual machine firmware volumes";
    homepage = "https://gitlab.com/kraxel/virt-firmware";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      raitobezarius
    ];
  };
}
