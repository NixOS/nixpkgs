{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  nix-update-script,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  # The distribution is published as `uefi_firmware`; the project and its
  # binary are `uefi-firmware-parser`.
  pname = "uefi_firmware";
  version = "1.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theopolis";
    repo = "uefi-firmware-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2vYTOC7cOiQXPMhYM+hqmFyCJeXCkx6RSxgaTIZqbds=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRemoveDeps = [ "future" ];

  pythonImportsCheck = [ "uefi_firmware" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for parsing, extracting, and recreating UEFI firmware volumes";
    homepage = "https://github.com/theopolis/uefi-firmware-parser";
    changelog = "https://github.com/theopolis/uefi-firmware-parser/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "uefi-firmware-parser";
    maintainers = [ lib.maintainers.elliotberman ];
    platforms = lib.platforms.unix;
  };
})
