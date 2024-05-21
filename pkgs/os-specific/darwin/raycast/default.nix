{ lib
, stdenvNoCC
, fetchurl
, writeShellApplication
, curl
, jq
, common-updater-scripts
, undmg
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "raycast";
  version = "1.74.1";

  src = fetchurl {
    name = "Raycast.dmg";
    url = "https://releases.raycast.com/releases/${finalAttrs.version}/download?build=universal";
    hash = "sha256-vIhuXZ9FxpWLPoOciyl4Qe0G8vXY+to+CGxp+nRmyp8=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ undmg ];

  sourceRoot = "Raycast.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Raycast.app
    cp -R . $out/Applications/Raycast.app

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "raycast-update-script";
    runtimeInputs = [ curl jq common-updater-scripts ];
    text = ''
      set -eo pipefail
      url=$(curl --silent "https://releases.raycast.com/releases/latest?build=universal")
      version=$(echo "$url" | jq -r '.version')
      update-source-version raycast "$version" --file=./pkgs/os-specific/darwin/raycast/default.nix
    '';
  });

  meta = with lib; {
    description = "Control your tools with a few keystrokes";
    homepage = "https://raycast.app/";
    license = with licenses; [ unfree ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ lovesegfault stepbrobd donteatoreo ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  };
})
