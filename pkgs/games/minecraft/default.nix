{ lib, nixosTests, buildFHSEnv, fetchurl, makeDesktopItem }:
let
  version-info = builtins.fromJSON (builtins.readFile ./version.json);
  bootstrap = fetchurl { inherit (version-info) url hash; executable = true;}; # Main executable, downloads & updates main launcher

  desktopItem = makeDesktopItem {
    name = "minecraft-launcher";
    exec = "minecraft-launcher";
    icon = "minecraft-launcher";
    comment = "Official launcher for Minecraft, a sandbox-building game";
    desktopName = "Minecraft Launcher";
    categories = [ "Game" ];
  };

  icon = fetchurl {
    url = "https://launcher.mojang.com/download/minecraft-launcher.svg";
    sha256 = "0w8z21ml79kblv20wh5lz037g130pxkgs8ll9s3bi94zn2pbrhim";
  };
in

buildFHSEnv {
  name = null;
  pname = "minecraft-launcher";
  version = version-info.version;
  unsharePid = false; # The launcher writes a PID-based lockfile, and has a tendacy to kill random processes if it's in a PID namespace
  targetPkgs = pkgs: with pkgs; ([ libsecret mesa libdrm curl libpulseaudio systemd flite alsa-lib atk cairo cups dbus expat fontconfig freetype gdk-pixbuf glib pango gtk3-x11 gtk2-x11 nspr nss stdenv.cc.cc zlib libuuid ] ++ (with xorg; [ libX11 libxcb libXcomposite libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender libXtst libXScrnSaver ])); # TODO: clean up; only what's needed

  runScript = bootstrap;

  extraInstallCommands = ''
    install -D ${desktopItem}/share/applications/minecraft-launcher.desktop $out/share/applications/minecraft-launcher.desktop
    install -D ${icon} $out/share/icons/hicolor/symbolic/apps/minecraft-launcher.svg
  '';

  meta = with lib; {
    description = "Official launcher for Minecraft, a sandbox-building game";
    homepage = "https://minecraft.net";
    maintainers = with maintainers; [ cpages ryantm infinisil JimSpoonbaker ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };

  passthru = {
    tests = { inherit (nixosTests) minecraft; };
    updateScript = ./update.sh;
  };
}


# TODO:
# - only needed libraries
#   - libsecret
# - Don't need FHSEnv? only LD_LIBRARY_PATH?
# - make sure nixos test passes
# - Wayland? (launcher)
# - enable using system libglfw? (game wayland) https://github.com/Admicos/minecraft-wayland
