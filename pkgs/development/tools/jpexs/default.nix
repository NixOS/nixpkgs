{ stdenv, fetchzip, makeWrapper, makeDesktopItem, jdk8 }:

stdenv.mkDerivation rec {
  pname = "jpexs";
  version = "11.3.0";

  src = fetchzip {
    url = "${meta.homepage}/releases/download/version${version}/ffdec_${version}.zip";
    sha256 = "0d1xmq21vdpn0glwfzr00s62ic8jynmgmgxl0m1834xqf3ma0ihv";
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
    categories = "Development;Java;";
    extraEntries = ''
      StartupWMClass=com-jpexs-decompiler-flash-gui-Main
    '';
  };

  meta = with stdenv.lib; {
    description = "Flash SWF decompiler and editor";
    longDescription = ''
      Open-source Flash SWF decompiler and editor. Extract resources,
      convert SWF to FLA, edit ActionScript, replace images, sounds,
      texts or fonts.
    '';
    homepage = "https://github.com/jindrapetrik/jpexs-decompiler";
    license = licenses.gpl3;
    platforms = jdk8.meta.platforms;
    maintainers = with maintainers; [ samuelgrf ];
  };
}
