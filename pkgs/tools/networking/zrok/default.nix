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
    x86_64-linux = "sha256-lI9FmAvUTzfukxyhjbB4mULURSQNhLcLbZ0NzIDem0g=";
    aarch64-linux = "sha256-A77yPDC3MVDhc4Le+1XmHl/HRc0keYDfnS3kM1hQYL4=";
    armv7l-linux = "sha256-khl0g8IDHtB53Sg4IdRzQs7A+FmUZyT/1dpKVTGnMs8=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation rec {
  pname = "zrok";
  version = "0.4.5";

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
