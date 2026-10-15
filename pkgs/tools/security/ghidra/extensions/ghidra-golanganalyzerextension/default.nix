{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
}:
buildGhidraExtension (finalAttrs: {
  pname = "Ghidra-GolangAnalyzerExtension";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "mooncat-greenpy";
    repo = "Ghidra_GolangAnalyzerExtension";
    rev = finalAttrs.version;
    hash = "sha256-bd0NmIql4OHxaWtSvNvbJZLiJUjaRKgkA+nCSiVo478=";
  };

  sourceRoot = "${finalAttrs.src.name}/GolangAnalyzerExtension";

  meta = {
    description = "Facilitates the analysis of Golang binaries using Ghidra";
    homepage = "https://github.com/mooncat-greenpy/Ghidra_GolangAnalyzerExtension";
    downloadPage = "https://github.com/mooncat-greenpy/Ghidra_GolangAnalyzerExtension/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ivyfanchiang ];
  };
})
