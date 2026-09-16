{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
  gradle,
}:
buildGhidraExtension (finalAttrs: {
  pname = "reva";
  version = "7.3.1";

  src = fetchFromGitHub {
    owner = "cyberkaida";
    repo = "reverse-engineering-assistant";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eYZeyhXlGwLVa/k77Y5x2OeGo/m9fh3VauzAqB+obxw=";
  };

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  meta = {
    description = "MCP server for reverse engineering tasks in Ghidra";
    homepage = "https://github.com/cyberkaida/reverse-engineering-assistant";
    downloadPage = "https://github.com/cyberkaida/reverse-engineering-assistant/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brianmcgillion ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
