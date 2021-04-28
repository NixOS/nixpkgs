{ lib, appimageTools, fetchurl }: let
  pname = "flexoptix-app";
  version = "5.9.0";
  name = "${pname}-${version}";

  src = fetchurl {
    name = "${name}.AppImage";
    url = "https://flexbox.reconfigure.me/download/electron/linux/x64/FLEXOPTIX%20App.${version}.AppImage";
    sha256 = "0gbqaj9b11mxx0knmmh2d5863kaslbb3r6c4h8rjhg8qy4cws7hj";
  };

  udevRules = fetchurl {
    url = "https://www.flexoptix.net/skin/udev_rules/99-tprogrammer.rules";
    sha256 = "0mr1bhgvavq1ax4206z1vr2y64s3r676w9jjl9ysziklbrsvk5rr";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in appimageTools.wrapType2 {
  inherit name src;

  multiPkgs = null; # no 32bit needed
  extraPkgs = { pkgs, ... }@args: [
    pkgs.hidapi
  ] ++ appimageTools.defaultFhsEnvArgs.multiPkgs args;

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -Dm444 ${appimageContents}/flexoptix-app.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/flexoptix-app.png -t $out/share/pixmaps
    substituteInPlace $out/share/applications/flexoptix-app.desktop \
      --replace 'Exec=AppRun' "Exec=$out/bin/${pname}"
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
