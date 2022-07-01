{ clonehero-unwrapped
, makeDesktopItem
, buildFHSUserEnv
, liberation_ttf
, callPackage
}:

let
  name = "clonehero";
  desktopName = "Clone Hero";
  desktopItem = makeDesktopItem {
    inherit name desktopName;
    comment = clonehero-unwrapped.meta.description;
    exec = name;
    icon = name;
    categories = [ "Game" ];
  };
in
buildFHSUserEnv {
  inherit name;
  inherit (clonehero-unwrapped) meta;

  # Clone Hero has /usr/share/fonts hard-coded in its binary for looking up fonts.
  # This workaround is necessary for rendering text on the keybinding screen (and possibly elsewhere)
  # If a better solution is found, the FHS environment can be removed.
  extraBuildCommands = ''
    chmod +w usr/share
    mkdir -p usr/share/fonts/truetype
    ln -s ${liberation_ttf}/share/fonts/truetype/* usr/share/fonts/truetype
  '';

  extraInstallCommands = ''
    mkdir -p "$out/share/applications" "$out/share/pixmaps"
    cp ${desktopItem}/share/applications/* "$out/share/applications"
    ln -s ${clonehero-unwrapped}/share/clonehero_Data/Resources/UnityPlayer.png "$out/share/pixmaps/${name}.png"
  '';

  runScript = callPackage ./xdg-wrapper.nix { };
}
