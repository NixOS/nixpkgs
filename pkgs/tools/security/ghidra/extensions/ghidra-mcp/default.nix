{
  fetchFromGitHub,
  ghidra,
  lib,
}:

ghidra.buildGhidraExtension (finalAttrs: {
  pname = "ghidra-mcp";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "bethington";
    repo = "ghidra-mcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L1NldAplskN/3pR0juHNLBcWB39TdhvQ0U82cAL7d18=";
  };

  postInstall = ''
    # Upstream ships Module.manifest as simple key/value metadata.
    # Ghidra expects either an empty manifest or directive-style entries.
    : > "$out/lib/ghidra/Ghidra/Extensions/GhidraMCP/Module.manifest"
  '';

  meta = {
    description = "Model Context Protocol extension for Ghidra";
    homepage = "https://github.com/bethington/ghidra-mcp";
    downloadPage = "https://github.com/bethington/ghidra-mcp/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/bethington/ghidra-mcp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.caverav ];
    platforms = ghidra.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
