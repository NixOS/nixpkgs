{ copyDesktopItems, fetchurl, jre, lib, makeDesktopItem, makeWrapper, stdenv, udev, xorg }:

stdenv.mkDerivation (finalAttrs: {
  pname = "atlauncher";
  version = "3.4.34.2";

  src = fetchurl {
    url = "https://github.com/ATLauncher/ATLauncher/releases/download/v${finalAttrs.version}/ATLauncher-${finalAttrs.version}.jar";
    hash = "sha256-l9OoHunK0xfY6xbNpjs9lfsVd3USM1GHgutTMMVq8S8=";
  };

  env.ICON = fetchurl {
    url = "https://atlauncher.com/assets/images/logo.svg";
    hash = "sha256-XoqpsgLmkpa2SdjZvPkgg6BUJulIBIeu6mBsJJCixfo=";
  };

  dontUnpack = true;

  buildInputs = [ ];
  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java
    cp $src $out/share/java/ATLauncher.jar

    makeWrapper ${jre}/bin/java $out/bin/${finalAttrs.pname} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ xorg.libXxf86vm udev ]}" \
      --add-flags "-jar $out/share/java/ATLauncher.jar" \
      --add-flags "--working-dir \"\''${XDG_DATA_HOME:-\$HOME/.local/share}/ATLauncher\"" \
      --add-flags "--no-launcher-update"

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp $ICON $out/share/icons/hicolor/scalable/apps/${finalAttrs.pname}.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = finalAttrs.pname;
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
