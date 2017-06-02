{ stdenv, nitrokey-app
, group ? "nitrokey"
}:

stdenv.mkDerivation {
  name = "nitrokey-udev-rules";

  inherit (nitrokey-app) src;

  dontBuild = true;

  patchPhase = ''
    substituteInPlace data/41-nitrokey.rules --replace plugdev "${group}"
  '';

  installPhase = ''
    mkdir -p $out/etc/udev/rules.d
    cp data/41-nitrokey.rules $out/etc/udev/rules.d
  '';

  meta = {
    description = "udev rules for Nitrokeys";
    inherit (nitrokey-app.meta) homepage license maintainers;
  };
}
