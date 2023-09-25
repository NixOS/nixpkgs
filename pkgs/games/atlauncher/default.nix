{ copyDesktopItems, fetchurl, jre, lib, makeDesktopItem, makeWrapper, stdenv, steam-run, withSteamRun ? true, writeShellScript }:

stdenv.mkDerivation (finalAttrs: {
  pname = "atlauncher";
  version = "3.4.34.0";

  src = fetchurl {
    url = "https://github.com/ATLauncher/ATLauncher/releases/download/v${finalAttrs.version}/ATLauncher-${finalAttrs.version}.jar";
    hash = "sha256-gHUYZaxADchikoCmAfqFjVbMYhhiwg2BZKctmww1Mlw=";
  };

  env.ICON = fetchurl {
    url = "https://atlauncher.com/assets/images/logo.svg";
    hash = "sha256-XoqpsgLmkpa2SdjZvPkgg6BUJulIBIeu6mBsJJCixfo=";
  };

  dontUnpack = true;

  buildInputs = [ ];
  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  installPhase =
    let
      # hack to use steam-run along with the exec
      steamrun = writeShellScript "steamrun" ''
        shift
        exec ${steam-run}/bin/steam-run "''$@"
      '';
    in
    ''
      runHook preInstall
      mkdir -p $out/bin
      makeWrapper ${jre}/bin/java $out/bin/atlauncher \
        --add-flags "-jar $src --working-dir=\$HOME/.atlauncher" \
        --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}" ${
            lib.strings.optionalString withSteamRun ''--run "${steamrun} \\"''
          }

      mkdir -p $out/share/icons/hicolor/scalable/apps
      cp $ICON $out/share/icons/hicolor/scalable/apps/${finalAttrs.pname}.svg

      runHook postInstall
    '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = "${finalAttrs.pname} --no-launcher-update true";
      icon = finalAttrs.pname;
      desktopName = "ATLauncher";
      categories = [ "Game" ];
    })
  ];

  meta = with lib; {
    description = "A simple and easy to use Minecraft launcher which contains many different modpacks for you to choose from and play";
    downloadPage = "https://atlauncher.com/downloads";
    homepage = "https://atlauncher.com/";
    license = licenses.gpl3;
    maintainers = [ maintainers.getpsyched ];
    platforms = platforms.all;
  };
})
