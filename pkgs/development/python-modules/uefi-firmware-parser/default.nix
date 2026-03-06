{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "uefi-firmware-parser";
  version = "1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theopolis";
    repo = "uefi-firmware-parser";
    tag = "v${version}";
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
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "uefi-firmware-parser";
  };
}
