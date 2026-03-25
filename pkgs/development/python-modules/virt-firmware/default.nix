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

buildPythonPackage (finalAttrs: {
  pname = "virt-firmware";
  version = "25.12";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "kraxel";
    repo = "virt-firmware";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sopmWZ8CdLuc0R+QN7MSoqT9kURzOyh9CgbreKuvANw=";
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

  meta = {
    description = "Tools for virtual machine firmware volumes";
    homepage = "https://gitlab.com/kraxel/virt-firmware";
    changelog = "https://gitlab.com/kraxel/virt-firmware/-/tags/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      raitobezarius
    ];
  };
})
