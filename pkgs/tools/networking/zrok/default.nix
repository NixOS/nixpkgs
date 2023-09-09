{ lib, stdenv, fetchzip }:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
    armv7l-linux = "linux_armv7";
  }.${system} or throwSystem;

  sha256 = {
    x86_64-linux = "sha256-w3BF5Zu68e7X6vfkJhUTS6wkg7LSFZunx9dnBA2Ao5c=";
    aarch64-linux = "sha256-hJiXDydUF750mTsFIXH6X8AjzjaG2Iaa+TzsCCCVAvs=";
    armv7l-linux = "sha256-lEPo6Y+cqlG2QflwJdG/MNqFLMPdwQLI0+TC/VVlGV4=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "zrok";
  version = "0.4.6";

  src = fetchzip {
    url = "https://github.com/openziti/zrok/releases/download/v${version}/zrok_${version}_${plat}.tar.gz";
    stripRoot = false;
    inherit sha256;
  };

  updateScript = ./update.sh;

  installPhase = let
    interpreter = "$(< \"$NIX_CC/nix-support/dynamic-linker\")";
  in ''
    mkdir -p $out/bin
    cp zrok $out/bin/
    chmod +x $out/bin/zrok
    patchelf --set-interpreter "${interpreter}" "$out/bin/zrok"
  '';

  meta = {
    description = "Geo-scale, next-generation sharing platform built on top of OpenZiti";
    homepage = "https://zrok.io";
    maintainers = [ lib.maintainers.bandresen ];
    platforms = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
  };

}
