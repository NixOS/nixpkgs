{
  soundfont-fluid,
  buildFHSEnv,
  runCommand,
  callPackage,
}:

let
  space-station-14-launcher = callPackage ./space-station-14-launcher.nix { };

  # Workaround for hardcoded soundfont paths in downloaded engine assemblies.
  soundfont-fluid-fixed = runCommand "soundfont-fluid-fixed" { } ''
    mkdir -p "$out/share/soundfonts"
    ln -sf ${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2 $out/share/soundfonts/FluidR3_GM.sf2
  '';
in
buildFHSEnv rec {
  name = "space-station-14-launcher-wrapped";

  targetPkgs = pkgs: [
    space-station-14-launcher
    soundfont-fluid-fixed
  ];

  runScript = "SS14.Launcher";

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    ln -s ${space-station-14-launcher}/share/icons $out/share
    cp ${space-station-14-launcher}/share/applications/space-station-14-launcher.desktop "$out/share/applications"
    substituteInPlace "$out/share/applications/space-station-14-launcher.desktop" \
        --replace ${space-station-14-launcher.meta.mainProgram} ${meta.mainProgram}
  '';

  passthru = space-station-14-launcher.passthru // {
    unwrapped = space-station-14-launcher;
  };
  meta = space-station-14-launcher.meta // {
    mainProgram = name;
  };
}
