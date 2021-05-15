{ lib, stdenv, nitrokey-app }:


stdenv.mkDerivation {
  name = "nitrokey-udev-rules-${lib.getVersion nitrokey-app}";

  inherit (nitrokey-app) src;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/etc/udev/rules.d
    cp libnitrokey/data/41-nitrokey.rules $out/etc/udev/rules.d
  '';

  meta = {
    description = "udev rules for Nitrokeys";
    inherit (nitrokey-app.meta) homepage license maintainers;
  };
}
