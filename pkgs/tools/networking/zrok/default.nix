{
  lib,
  stdenv,
  fetchzip,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat =
    {
      x86_64-linux = "linux_amd64";
      aarch64-linux = "linux_arm64";
      armv7l-linux = "linux_armv7";
    }
    .${system} or throwSystem;

  hash =
    {
      x86_64-linux = "sha256-8fEmiRKFOrF9v66OEfUGLUYK+DfZMkAXrCKu2DoGbLA=";
      aarch64-linux = "sha256-p+YbWpyLfIgFdNvakQQFfi+P/9lhfVMM+Y0XynRJ/rY=";
      armv7l-linux = "sha256-mMjtbAjylSjS+89T0qQoI4H/p316cqh+5fbgarFbv90=";
    }
    .${system} or throwSystem;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zrok";
  version = "0.4.34";

  src = fetchzip {
    url = "https://github.com/openziti/zrok/releases/download/v${finalAttrs.version}/zrok_${finalAttrs.version}_${plat}.tar.gz";
    stripRoot = false;
    inherit hash;
  };

  updateScript = ./update.sh;

  installPhase =
    let
      interpreter = "$(< \"$NIX_CC/nix-support/dynamic-linker\")";
    in
    ''
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
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "armv7l-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
