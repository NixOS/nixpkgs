{
  lib,
  pkgs,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  cryptography,
  pytestCheckHook,
  pefile,
}:

buildPythonPackage rec {
  pname = "virt-firmware";
  version = "25.7.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "kraxel";
    repo = "virt-firmware";
    rev = "refs/tags/v${version}";
    hash = "sha256-kuFTKMhBVlgCBYLTO23IUz/tRLoMRHxjWPIaauu/PWw=";
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

  enabledTestPaths = [ "tests/tests.py" ];

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
