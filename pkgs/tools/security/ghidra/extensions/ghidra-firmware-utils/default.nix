{
  buildGhidraExtension,
  fetchFromGitHub,
  lib,
}:
buildGhidraExtension (finalAttrs: {
  pname = "ghidra-firmware-utils";
  version = "2025.12.14";

  src = fetchFromGitHub {
    owner = "al3xtjames";
    repo = "ghidra-firmware-utils";
    rev = finalAttrs.version;
    hash = "sha256-dg3b2Ft7fFRGhWhZILEEKY3hAXk0Ha4dwDusgkPgZ34=";
  };

  meta = {
    description = "Ghidra utilities for analyzing PC firmware";
    homepage = "https://github.com/al3xtjames/ghidra-firmware-utils";
    downloadPage = "https://github.com/al3xtjames/ghidra-firmware-utils/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timschumi ];
  };
})
