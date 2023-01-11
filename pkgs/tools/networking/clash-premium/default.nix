{ lib
, stdenvNoCC
, fetchurl
, gzip
, writeShellScript
, curl
, jq
, common-updater-scripts
, coreutils
}:

stdenvNoCC.mkDerivation rec {
  pname = "clash-premium";
  version = "2022.11.25";

  src = passthru.sources.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  unpackPhase = ''
    ${gzip}/bin/gzip -dc $src > clash
  '';

  installPhase = ''
    runHook preInstall
    install -Dm 755 clash $out/bin/clash-premium
    runHook postInstall
  '';

  passthru = {
    sources = {
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/Dreamacro/clash/releases/download/premium/clash-darwin-arm64-${version}.gz";
        sha256 = "gQb6l4H8ZjroAC7TEAm2LTWsnCS7CEXmitVOgso55Qk=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-arm64-${version}.gz";
        sha256 = "rLHyBKHiJ2sh3u1enMbCnuj9cvrblsG+6b+ItKaM8FU=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/Dreamacro/clash/releases/download/premium/clash-darwin-amd64-${version}.gz";
        sha256 = "aXs3/sJAfZDEpOnXY6RfMs6EHyNbUYOx7ZQJ4ONDMCM=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-amd64-${version}.gz";
        sha256 = "1s4K+rjlwWqXrCE2L8QveFL8CTgvGMYzniuZMgY1+eE=";
      };
    };
    updateScript = writeShellScript "update-clash-premium" ''
      set -o errexit
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts coreutils ]}"
      TITLE=$(curl "https://api.github.com/repos/Dreamacro/clash/releases/26312156" | jq -r .name)
      NEW_VERSION=$(echo $TITLE | cut -b 9-18)
      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs meta.platforms}; do
        update-source-version "clash-premium" "0" "${lib.fakeSha256}" --source-key="sources.$platform"
        update-source-version "clash-premium" "$NEW_VERSION" --source-key="sources.$platform"
      done
    '';
  };

  meta = with lib; {
    homepage = "https://github.com/Dreamacro/clash/releases/tag/premium";
    description = "Close-sourced pre-built Clash binary with TUN support";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ candyc1oud ];
    platforms = builtins.attrNames passthru.sources;
  };
}
