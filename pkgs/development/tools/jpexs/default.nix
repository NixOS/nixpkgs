{ lib, stdenv, fetchzip, makeWrapper, makeDesktopItem, jdk8 }:

stdenv.mkDerivation rec {
  pname = "jpexs";
  version = "18.4.1";

  src = fetchzip {
    url = "https://github.com/jindrapetrik/jpexs-decompiler/releases/download/version${version}/ffdec_${version}.zip";
    sha256 = "sha256-aaEL3xJZkFw78zo3IyauWJM9kOo0rJTUSKmWsv9xQZ8=";
    stripRoot = false;
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/{ffdec,icons/hicolor/512x512/apps}

    cp ffdec.jar $out/share/ffdec
    cp -r lib $out/share/ffdec
    cp icon.png $out/share/icons/hicolor/512x512/apps/ffdec.png
    cp -r ${desktopItem}/share/applications $out/share

    makeWrapper ${jdk8}/bin/java $out/bin/ffdec \
      --add-flags "-jar $out/share/ffdec/ffdec.jar"
  '';

  desktopItem = makeDesktopItem rec {
    name = "ffdec";
    exec = name;
    icon = name;
    desktopName = "JPEXS Free Flash Decompiler";
    genericName = "Flash Decompiler";
    comment = meta.description;
    categories = [ "Development" "Java" ];
    startupWMClass = "com-jpexs-decompiler-flash-gui-Main";
  };

  meta = with lib; {
    description = "Flash SWF decompiler and editor";
    mainProgram = "ffdec";
    longDescription = ''
      Open-source Flash SWF decompiler and editor. Extract resources,
      convert SWF to FLA, edit ActionScript, replace images, sounds,
      texts or fonts.
    '';
    homepage = "https://github.com/jindrapetrik/jpexs-decompiler";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3;
    platforms = jdk8.meta.platforms;
    maintainers = [ ];
  };
}
