{
  buildGhidraExtension,
  fetchFromGitHub,
  lib,
}:
buildGhidraExtension (finalAttrs: {
  pname = "ghidra-firmware-utils";
  version = "2026.08.31";

  src = fetchFromGitHub {
    owner = "al3xtjames";
    repo = "ghidra-firmware-utils";
    rev = finalAttrs.version;
    hash = "sha256-M2GC2LHitZ9kJ5lOMb8koi4sxXGwXn119KXNb9BYArA=";
  };

  meta = {
    description = "Ghidra utilities for analyzing PC firmware";
    homepage = "https://github.com/al3xtjames/ghidra-firmware-utils";
    downloadPage = "https://github.com/al3xtjames/ghidra-firmware-utils/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timschumi ];
  };
})
