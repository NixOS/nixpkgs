{
  fetchurl,
  ghidra,
  lib,
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ghidramcp";
  version = "1.4";

  src = fetchurl {
    url = "https://github.com/LaurieWired/GhidraMCP/releases/download/${finalAttrs.version}/GhidraMCP-release-1-4.zip";
    hash = "sha256-uBylJA/d5X6k6JkXDc2f3ubtKSRigMdCY6UJv8/H5zQ=";
  };

  nativeBuildInputs = [ unzip ];
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    releaseDir="$(mktemp -d)"
    unzip -q "$src" -d "$releaseDir"

    extensionZip="$(find "$releaseDir" -type f -name 'GhidraMCP-*.zip' | head -n1)"
    if [ -z "$extensionZip" ]; then
      echo "Failed to locate GhidraMCP extension zip in release archive" >&2
      exit 1
    fi

    mkdir -p "$out/lib/ghidra/Ghidra/Extensions"
    unzip -q "$extensionZip" -d "$out/lib/ghidra/Ghidra/Extensions"

    # Prevent attempted creation of plugin lock files in the Nix store.
    for i in "$out"/lib/ghidra/Ghidra/Extensions/*; do
      touch "$i/.dbDirLock"
    done

    runHook postInstall
  '';

  meta = {
    description = "Model Context Protocol extension for Ghidra";
    homepage = "https://github.com/LaurieWired/GhidraMCP";
    downloadPage = "https://github.com/LaurieWired/GhidraMCP/releases/tag/${finalAttrs.version}";
    changelog = "https://github.com/LaurieWired/GhidraMCP/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.caverav ];
    platforms = ghidra.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
