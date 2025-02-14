{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension rec {
  pname = "Ghidra-GolangAnalyzerExtension";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "mooncat-greenpy";
    repo = "Ghidra_GolangAnalyzerExtension";
    rev = version;
    hash = "sha256-uxozIJ+BLcP1vBnLOCZD9ueY10hd37fON/Miii3zabo=";
  };

  meta = {
    description = "Facilitates the analysis of Golang binaries using Ghidra";
    homepage = "https://github.com/mooncat-greenpy/Ghidra_GolangAnalyzerExtension";
    downloadPage = "https://github.com/mooncat-greenpy/Ghidra_GolangAnalyzerExtension/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ivyfanchiang ];
  };
}
