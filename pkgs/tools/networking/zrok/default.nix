{ lib
, stdenv
, fetchzip
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
    armv7l-linux = "linux_armv7";
  }.${system} or throwSystem;

  hash = {
    x86_64-linux = "sha256-1CdYmFKpjc3CAmHwpSJ3IL4ZrJqYo0QZ4a/yRy732IM=";
    aarch64-linux = "sha256-Du/Kyb4UafEK3ssfWB3w0harAxUIlmsc5SGsxf1Dc18=";
    armv7l-linux = "sha256-59tQ5sNk0QL1H+BjeiiJItTQUNWCNuWCp0wWe//VEhg=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zrok";
  version = "0.4.32";

  src = fetchzip {
    url = "https://github.com/openziti/zrok/releases/download/v${finalAttrs.version}/zrok_${finalAttrs.version}_${plat}.tar.gz";
    stripRoot = false;
    inherit hash;
  };

  updateScript = ./update.sh;

  installPhase = let
    interpreter = "$(< \"$NIX_CC/nix-support/dynamic-linker\")";
  in ''
    runHook preInstall

    mkdir -p $out/bin
    cp zrok $out/bin/
    chmod +x $out/bin/zrok
    patchelf --set-interpreter "${interpreter}" "$out/bin/zrok"

    runHook postInstall
  '';

  meta = {
    description = "Geo-scale, next-generation sharing platform built on top of OpenZiti";
    homepage = "https://zrok.io";
    license = lib.licenses.asl20;
    mainProgram = "zrok";
    maintainers = [ lib.maintainers.bandresen ];
    platforms = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
