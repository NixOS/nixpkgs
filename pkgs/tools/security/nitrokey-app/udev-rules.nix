{ stdenv, nitrokey-app
, group ? "nitrokey"
}:

stdenv.mkDerivation {
  name = "nitrokey-udev-rules-${stdenv.lib.getVersion nitrokey-app}";

  inherit (nitrokey-app) src;

  dontBuild = true;

  patchPhase = ''
    substituteInPlace libnitrokey/data/41-nitrokey.rules --replace plugdev "${group}"
  '';

  installPhase = ''
    mkdir -p $out/etc/udev/rules.d
    cp libnitrokey/data/41-nitrokey.rules $out/etc/udev/rules.d
  '';

  meta = {
    description = "udev rules for Nitrokeys";
    inherit (nitrokey-app.meta) homepage license maintainers;
  };
}
