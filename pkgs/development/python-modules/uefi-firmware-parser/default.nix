{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "uefi-firmware-parser";
  version = "1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theopolis";
    repo = "uefi-firmware-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yiw9idmvSpx4CcVrXHznR8vK/xl7DTL+L7k4Nvql2B8=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonRemoveDeps = [ "future" ];

  pythonImportsCheck = [ "uefi_firmware" ];

  meta = {
    description = "Tool for parsing, extracting, and recreating UEFI firmware volumes";
    homepage = "https://github.com/theopolis/uefi-firmware-parser";
    changelog = "https://github.com/theopolis/uefi-firmware-parser/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "uefi-firmware-parser";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
