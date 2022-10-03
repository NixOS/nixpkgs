{ lib
, stdenv
, fetchurl
, jre
, imagemagick
, makeWrapper
, makeDesktopItem
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  pname = "hmcl";
  version = "3.5.3.223";

  src = fetchurl {
    url = "https://github.com/huanghongxun/HMCL/releases/download/v${version}/HMCL-${version}.jar";
    sha256 = "sha256-8g2FMvAiAKfxJUY0G7wl6d44wOpVsknFHGZ85IkOzFc=";
  };

  icon = fetchurl {
    url = "https://github.com/huanghongxun/HMCL/raw/v${version}/HMCLauncher/HMCL/HMCL.ico";
    sha256 = "sha256-MWp78rP4b39Scz5/gpsjwaJhSu+K9q3S2B2cD/V31MA";
  };

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper copyDesktopItems imagemagick ];

  desktopItems = lib.toList (makeDesktopItem {
    name = "hmcl";
    exec = "hmcl";
    icon = "hmcl";
    comment = "A Minecraft Launcher which is multi-functional, cross-platform and popular";
    desktopName = "HMCL";
    categories = [ "Game" ];
  });

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/java/hmcl
    install -Dm644 $src $out/share/java/hmcl/hmcl.jar
    magick $icon icon.png
    install -Dm644 icon.png $out/share/icons/hicolor/32x32/apps/hmcl.png
    makeWrapper ${jre}/bin/java $out/bin/hmcl \
      --add-flags "-jar $out/share/java/hmcl/hmcl.jar" \
      --prefix PATH : ${lib.makeBinPath [ jre ]} \
      --set JAVA_HOME ${jre.home}
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Minecraft Launcher which is multi-functional, cross-platform and popular";
    homepage = "https://hmcl.huangyuhui.net";
    changelog = "https://hmcl.huangyuhui.net/changelog/dev.html";
    maintainers = with maintainers; [ candyc1oud ];
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    inherit (jre.meta) platforms;
  };
}
