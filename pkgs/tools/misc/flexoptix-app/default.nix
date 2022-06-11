{ lib, appimageTools, fetchurl, nodePackages }: let
  pname = "flexoptix-app";
  version = "5.11.0";
  name = "${pname}-${version}";

  src = fetchurl {
    name = "${name}.AppImage";
    url = "https://flexbox.reconfigure.me/download/electron/linux/x64/FLEXOPTIX%20App.${version}.AppImage";
    hash = "sha256-Nj6S53b4w84qppkGB7lMpJhJlxifaD4acPryuZxY7cM=";
  };

  udevRules = fetchurl {
    url = "https://www.flexoptix.net/skin/udev_rules/99-tprogrammer.rules";
    hash = "sha256-OZe5dV50xq99olImbo7JQxPjRd7hGyBIVwFvtR9cIVc=";
  };

  appimageContents = (appimageTools.extract { inherit name src; }).overrideAttrs (oA: {
    buildCommand = ''
      ${oA.buildCommand}

      # Get rid of the autoupdater
      ${nodePackages.asar}/bin/asar extract $out/resources/app.asar app
      sed -i 's/async isUpdateAvailable.*/async isUpdateAvailable(updateInfo) { return false;/g' app/node_modules/electron-updater/out/AppUpdater.js
      ${nodePackages.asar}/bin/asar pack app $out/resources/app.asar
    '';
  });

in appimageTools.wrapAppImage {
  inherit name;
  src = appimageContents;

  multiPkgs = null; # no 32bit needed
  extraPkgs = { pkgs, ... }@args: [
    pkgs.hidapi
  ] ++ appimageTools.defaultFhsEnvArgs.multiPkgs args;

  extraInstallCommands = ''
    # Add desktop convencience stuff
    mv $out/bin/{${name},${pname}}
    install -Dm444 ${appimageContents}/flexoptix-app.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/flexoptix-app.png -t $out/share/pixmaps
    substituteInPlace $out/share/applications/flexoptix-app.desktop \
      --replace 'Exec=AppRun' "Exec=$out/bin/${pname} --"

    # Add udev rules
    mkdir -p $out/lib/udev/rules.d
    ln -s ${udevRules} $out/lib/udev/rules.d/99-tprogrammer.rules
  '';

  meta = {
    description = "Configure FLEXOPTIX Universal Transcievers in seconds";
    homepage = "https://www.flexoptix.net";
    changelog = "https://www.flexoptix.net/en/flexoptix-app/?os=linux#flexapp__modal__changelog";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ das_j ];
    platforms = [ "x86_64-linux" ];
  };
}
