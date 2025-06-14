{
  buildGhidraExtension,
  fetchFromGitHub,
  lib,
}:
buildGhidraExtension rec {
  pname = "ghidra-firmware-utils";
  version = "2024.04.20";

  src = fetchFromGitHub {
    owner = "al3xtjames";
    repo = "ghidra-firmware-utils";
    rev = version;
    hash = "sha256-BbPRSD1EzgMA3TCKHyNqLjzEgiOm67mLJuOeFOTvd0I=";
  };

  meta = {
    description = "Ghidra utilities for analyzing PC firmware";
    homepage = "https://github.com/al3xtjames/ghidra-firmware-utils";
    downloadPage = "https://github.com/al3xtjames/ghidra-firmware-utils/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timschumi ];
  };
}
