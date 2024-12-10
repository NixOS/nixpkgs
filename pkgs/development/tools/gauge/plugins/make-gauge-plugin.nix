{
  stdenvNoCC,
  fetchzip,
  lib,
  writeScript,
  autoPatchelfHook,
}:

{
  pname,
  data,
  repo,
  releasePrefix,
  isCrossArch ? false,
  meta,
  ...
}@args:
let
  otherArgs = lib.attrsets.removeAttrs args [
    "pname"
    "data"
    "repo"
    "releasePrefix"
    "isMultiArch"
  ];
  inherit (stdenvNoCC.hostPlatform) system;
  inherit (if isCrossArch then data else data.${system}) url hash;
  # Upstream uses a different naming scheme for platforms
  systemMap = {
    "x86_64-darwin" = "darwin.x86_64";
    "aarch64-darwin" = "darwin.arm64";
    "aarch64-linux" = "linux.arm64";
    "x86_64-linux" = "linux.x86_64";
  };
in
stdenvNoCC.mkDerivation (
  finalAttrs:
  (lib.recursiveUpdate {
    pname = "gauge-plugin-${pname}";
    inherit (data) version;

    src = fetchzip {
      inherit url hash;
      stripRoot = false;
    };

    nativeBuildInputs = lib.optional stdenvNoCC.hostPlatform.isLinux autoPatchelfHook;

    installPhase = ''
      mkdir -p "$out/share/gauge-plugins/${pname}/${finalAttrs.version}"
      cp -r . "$out/share/gauge-plugins/${pname}/${finalAttrs.version}"
    '';

    passthru.updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl nix-prefetch yq-go

      set -e

      dirname="pkgs/development/tools/gauge/plugins/${pname}"

      currentVersion=$(nix eval --raw -f default.nix gaugePlugins.${pname}.version)

      latestTag=$(curl -s ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/${repo}/releases/latest | yq ".tag_name")
      latestVersion="$(expr $latestTag : 'v\(.*\)')"

      tempfile=$(mktemp)

      if [[ "$FORCE_UPDATE" != "true" && "$currentVersion" == "$latestVersion" ]]; then
          echo "gauge-${pname} is up-to-date: ''${currentVersion}"
          exit 0
      fi

      yq -iPoj "{ \"version\": \"$latestVersion\" }" "$tempfile"

      updateSystem() {
          system=$1
          url=$2

          echo "Fetching hash for $system"
          hash=$(nix-prefetch-url --type sha256 $url --unpack)
          sriHash="$(nix hash to-sri --type sha256 $hash)"

          yq -iPoj '. + { "$system": { "url": "$url", "hash": "$sriHash" } }' "$tempfile"
      }

      updateSingle() {
          url=$1

          echo "Fetching hash"
          hash=$(nix-prefetch-url --type sha256 $url --unpack)
          sriHash="$(nix hash to-sri --type sha256 $hash)"

          yq -iPoj '. + { "url": "$url", "hash": "$sriHash" }' "$tempfile"
      }

      baseUrl="https://github.com/${repo}/releases/download/$latestTag/${releasePrefix}$latestVersion"

      ${
        if isCrossArch then
          "updateSingle \${baseUrl}.zip"
        else
          lib.concatStringsSep "\n" (
            map (
              platform: ''updateSystem "${platform}" "''${baseUrl}-${systemMap.${platform}}.zip"''
            ) meta.platforms
          )
      }

      mv "$tempfile" "$dirname/data.json"
    '';
  } otherArgs)
)
