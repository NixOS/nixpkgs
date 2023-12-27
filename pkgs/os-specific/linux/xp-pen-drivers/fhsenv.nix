{ config, lib, pkgs, xp-pentablet-unwrapped, buildFHSEnv }:

buildFHSEnv {
  name = "xp-pentablet";

  extraInstallCommands = ''
    mkdir -p "$out/share"
    ln -s ${xp-pentablet-unwrapped}/share/applications "$out/share"
    ln -s ${xp-pentablet-unwrapped}/share/icons "$out/share"
  '';

  runScript = "${xp-pentablet-unwrapped}/bin/xp-pentablet";

  # We have to add /usr/lib/pentablet but we can't mount into /usr because it's RO-mounted by default
  extraBwrapArgs = [ "--bind ${xp-pentablet-unwrapped}/usr /usr" ];

  #  runScript = "/usr/lib/pentablet/PenTablet";
  targetPkgs = pkgs: [
    xp-pentablet-unwrapped
  ];

  meta = xp-pentablet-unwrapped.meta;
}
