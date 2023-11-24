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
    x86_64-linux = "sha256-6oYZY1Ry4U/nR99DNsr7ZqTd/AAot+yrOHY75UXEuWY=";
    aarch64-linux = "sha256-/XAv/ptvUsWLF/iIOiqm/PoCLhVTL3Cnmd0YdqLBthk=";
    armv7l-linux = "sha256-CbtzY2q7HnqCcolTFyTphWbHN/VdSt/rs8q3tjHHNqc=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "zrok";
  version = "0.4.15";

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
