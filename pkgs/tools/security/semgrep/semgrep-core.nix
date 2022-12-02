{ lib, stdenvNoCC, callPackage }:

let
  common = callPackage ./common.nix { };
in
stdenvNoCC.mkDerivation rec {
  pname = "semgrep-core";
  inherit (common) version;

  src = common.coreRelease;

  installPhase = ''
    runHook preInstall
    install -Dm 755 -t $out/bin semgrep-core
    runHook postInstall
  '';

  meta = common.meta // {
    description = common.meta.description + " - core binary";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
