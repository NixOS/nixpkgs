{ stdenvNoCC
, fetchzip
, lib
, writeScript
}:

{ name
, data
, repo
, releasePrefix
, systemMap ? null
, ...
} @ args:
let
  otherArgs = lib.attrsets.removeAttrs args [ "name" "data" "repo" "releasePrefix" "systemMap" ];
  inherit (stdenvNoCC.hostPlatform) system;
  isMultiArch = systemMap != null;
  inherit (if isMultiArch then data.${system} else data) url hash;
in
stdenvNoCC.mkDerivation (finalAttrs: (lib.recursiveUpdate {
  pname = "gauge-plugin-${name}";
  inherit (data) version;

  src = fetchzip {
    inherit url hash;
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p "$out/share/gauge-plugins/${name}/${finalAttrs.version}"
    cp -r . "$out/share/gauge-plugins/${name}/${finalAttrs.version}"
  '';

  passthru.updateScript = writeScript "update-${finalAttrs.pname}" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl nix-prefetch yq-go

    set -e

    dirname="pkgs/development/tools/gauge/plugins/${name}"

    currentVersion=$(nix eval --raw -f default.nix gaugePlugins.${name}.version)

    latestTag=$(curl https://api.github.com/repos/${repo}/releases/latest | yq ".tag_name")
    latestVersion="$(expr $latestTag : 'v\(.*\)')"

    tempfile=$(mktemp)

    # if [[ "$currentVersion" == "$latestVersion" ]]; then
    #     echo "gauge-${name} is up-to-date: ''${currentVersion}"
    #     exit 0
    # fi

    yq -iPoj "{ \"version\": \"$latestVersion\" }" "$tempfile"

    updateSystem() {
        system=$1
        url=$2

        echo "Fetching hash for $system"
        hash=$(nix-prefetch-url --type sha256 $url --unpack)
        sriHash="$(nix hash to-sri --type sha256 $hash)"

        yq -iPoj ". + { \"$system\": { \"url\": \"$url\", \"hash\": \"$sriHash\" } }" "$tempfile"
    }

    updateSingle() {
        url=$1

        echo "Fetching hash"
        hash=$(nix-prefetch-url --type sha256 $url --unpack)
        sriHash="$(nix hash to-sri --type sha256 $hash)"

        yq -iPoj ". + { \"url\": \"$url\", \"hash\": \"$sriHash\" }" "$tempfile"
    }

    updateSingle() {
        url=$1

        echo "Fetching hash"
        hash=$(nix-prefetch-url --type sha256 $url)
        sriHash="$(nix hash to-sri --type sha256 $hash)"

        yq -iPoj ". + { \"url\": \"$url\", \"hash\": \"$sriHash\" }" "$tempfile"
    }

    baseUrl="https://github.com/${repo}/releases/download/$latestTag/${releasePrefix}$latestVersion"

    ${if isMultiArch then
        lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: ''updateSystem "${name}" "''${baseUrl}-${value}.zip"'') systemMap)
      else
        "updateSingle \${baseUrl}.zip"
    }

    mv "$tempfile" "$dirname/data.json"
  '';

  meta = {
    platforms = if isMultiArch then
                  lib.filter (name: name != "version") (lib.attrNames data)
                else
                  lib.platforms.all;
  };
} otherArgs))
