{ lib, stdenv, teck-programmer }:

stdenv.mkDerivation {
  pname = "teck-udev-rules";
  version = lib.getVersion teck-programmer;

  inherit (teck-programmer) src;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install 40-teck.rules -D -t $out/etc/udev/rules.d/
    runHook postInstall
  '';

  meta = {
    description = "udev rules for TECK keyboards";
    inherit (teck-programmer.meta) license;
    maintainers = [ lib.maintainers.bbjubjub ];
  };
}
